import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:service_app/src/core/utils/global_keys.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/database/offline_commissioning_db.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step2_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step3_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step4_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step5_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step6_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step4_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step5_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step6_usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart' hide SavedDescription;

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();

  factory OfflineSyncService() {
    return _instance;
  }

  OfflineSyncService._internal();

  bool _isSyncing = false;

  bool? _lastKnownConnectionStatus;

  void initialize() {
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        _syncOfflineReports();
      }
      
      // Only show snackbar if status changed (skip initial state if connected)
      if (_lastKnownConnectionStatus != null || status == InternetConnectionStatus.disconnected) {
        final isConnected = status == InternetConnectionStatus.connected;
        final snackBar = SnackBar(
          content: Text(
            isConnected ? "You are online" : "You are offline",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        );
        scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
        scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
      _lastKnownConnectionStatus = status == InternetConnectionStatus.connected;
    });
  }

  Future<void> _syncOfflineReports() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final db = OfflineCommissioningDb.instance;
      final reports = await db.getAllOfflineReports();

      for (var report in reports) {
        final id = report['id'] as String;
        final commissioningWorkId = report['commissioning_work_id'] as String;
        final isServiceReport = (report['is_service_report'] as int) == 1;

        String? serverReportId = id;

        try {
          // STEP 1
          if (report['step1'] != null) {
            final step1Data = jsonDecode(report['step1'] as String);
            if (isServiceReport) {
              final usecase = getIt<ServiceCallReportStep1Usecase>();
              final res = await usecase.call(ServiceCallReportStep1Params(
                complaintId: commissioningWorkId,
                technicianIds: List<Map<String, dynamic>>.from(step1Data['technician_ids']),
              ));
              res.fold((l) => throw Exception("Step 1 failed"), (r) {
                serverReportId = r.data.id;
              });
            } else {
              final usecase = getIt<CommissioningStep1Usecase>();
              final res = await usecase.call(CommissioningStep1Params(
                commissioningWorkId: commissioningWorkId,
                technicianIds: List<Map<String, dynamic>>.from(step1Data['technician_ids']),
              ));
              res.fold((l) => throw Exception("Step 1 failed"), (r) {
                serverReportId = r.data.id;
              });
            }
          }

          if (serverReportId == null) throw Exception("No server report ID after Step 1");

          // STEP 2
          if (report['step2'] != null) {
            final step2Data = jsonDecode(report['step2'] as String);
            if (isServiceReport) {
              final usecase = getIt<ServiceCallReportStep2Usecase>();
              final res = await usecase.call(ServiceCallReportStep2Params(
                id: serverReportId!,
                memberPresentsCustomerSide: step2Data['member_presents_customer_side'] ?? '',
                agenda: step2Data['agenda'] ?? '',
              ));
              res.fold((l) => throw Exception("Step 2 failed"), (r) {});
            } else {
              final usecase = getIt<CommissioningStep2Usecase>();
              final res = await usecase.call(CommissioningStep2Params(
                id: serverReportId!,
                memberPresentsCustomerSide: List<String>.from(step2Data['member_presents_customer_side']),
                agenda: step2Data['agenda'] ?? '',
                warrantyPeriodYears: step2Data['warranty_years'] ?? 1,
              ));
              res.fold((l) => throw Exception("Step 2 failed"), (r) {});
            }
          }

          // STEP 3
          if (report['step3'] != null) {
            final step3Data = jsonDecode(report['step3'] as String);
            TechnicalDetails? techDetails;
            if (step3Data['technical_details'] != null) {
              techDetails = TechnicalDetails.fromJson(step3Data['technical_details']);
            }
            if (isServiceReport) {
              final usecase = getIt<ServiceCallReportStep3Usecase>();
              final res = await usecase.call(ServiceCallReportStep3Params(
                id: serverReportId!,
                isTechnicalNa: step3Data['is_technical_na'] ?? false,
                technicalDetails: techDetails,
              ));
              res.fold((l) => throw Exception("Step 3 failed"), (r) {});
            } else {
              final usecase = getIt<CommissioningStep3Usecase>();
              final res = await usecase.call(CommissioningStep3Params(
                id: serverReportId!,
                isTechnicalNa: step3Data['is_technical_na'] ?? false,
                technicalDetails: techDetails,
              ));
              res.fold((l) => throw Exception("Step 3 failed"), (r) {});
            }
          }

          // STEP 4
          if (report['step4'] != null) {
            final step4Data = jsonDecode(report['step4'] as String);
            if (isServiceReport) {
              final usecase = getIt<ServiceCallReportStep4Usecase>();
              final res = await usecase.call(ServiceCallReportStep4Params(
                reportId: serverReportId!,
                descriptions: List<Map<String, dynamic>>.from(step4Data['descriptions']),
              ));
              res.fold((l) => throw Exception("Step 4 failed"), (r) {});
            } else {
              final usecase = getIt<CommissioningStep4Usecase>();
              final descriptions = (step4Data['descriptions'] as List)
                  .map<SavedDescription>((e) => SavedDescription(srNo: e['sr_no'], description: e['description']))
                  .toList();
              final res = await usecase.call(CommissioningStep4Params(
                id: serverReportId!,
                descriptions: descriptions,
              ));
              res.fold((l) => throw Exception("Step 4 failed"), (r) {});
            }
          }

          // STEP 5
          if (report['step5'] != null) {
            final step5Data = jsonDecode(report['step5'] as String);
            if (isServiceReport) {
              final usecase = getIt<ServiceCallReportStep5Usecase>();
              final res = await usecase.call(ServiceCallReportStep5Params(
                reportId: serverReportId!,
                isMechanicalChecklistNa: step5Data['is_mechanical_checklist_na'] ?? false,
                isPipelineChecklistNa: step5Data['is_pipeline_checklist_na'] ?? false,
                isElectricalChecklistNa: step5Data['is_electrical_checklist_na'] ?? false,
                checklistItems: List<Map<String, dynamic>>.from(step5Data['checklist_items']),
              ));
              res.fold((l) => throw Exception("Step 5 failed"), (r) {});
            } else {
              final usecase = getIt<CommissioningStep5Usecase>();
              final checklists = (step5Data['checklist_items'] as List).map((e) {
                return SavedChecklist(
                  id: "",
                  checkType: e['check_type'],
                  keyChecklist: e['key_checklist'],
                  valueChecklist: e['value_checklist'],
                  photo: e['photo'],
                  video: e['video'],
                );
              }).toList();
              final res = await usecase.call(CommissioningStep5Params(
                id: serverReportId!,
                isMechanicalChecklistNa: step5Data['is_mechanical_checklist_na'] ?? false,
                isPipelineChecklistNa: step5Data['is_pipeline_checklist_na'] ?? false,
                isElectricalChecklistNa: step5Data['is_electrical_checklist_na'] ?? false,
                checklistItems: checklists,
              ));
              res.fold((l) => throw Exception("Step 5 failed"), (r) {});
            }
          }

          // STEP 6
          if (report['step6'] != null) {
            final step6Data = jsonDecode(report['step6'] as String);
            if (isServiceReport) {
              final usecase = getIt<ServiceCallReportStep6Usecase>();
              final res = await usecase.call(ServiceCallReportStep6Params(
                id: serverReportId!,
                technicianRemarks: step6Data['technician_remarks'] ?? '',
                customerRemarks: step6Data['customer_remarks'] ?? '',
                technicianRepresentative: step6Data['technician_representative'] ?? '',
                customerRepresentativeName: step6Data['customer_representative_name'] ?? '',
                technicianSignaturePath: step6Data['technician_signature_path'],
                customerSignaturePath: step6Data['customer_signature_path'],
                workPhotosPaths: List<String>.from(step6Data['work_photos_paths']),
              ));
              res.fold((l) => throw Exception("Step 6 failed"), (r) {});
            } else {
              final usecase = getIt<CommissioningStep6Usecase>();
              final res = await usecase.call(CommissioningStep6Params(
                id: serverReportId!,
                technicianRemarks: step6Data['technician_remarks'] ?? '',
                customerRemarks: step6Data['customer_remarks'] ?? '',
                technicianRepresentative: step6Data['technician_representative'] ?? '',
                customerRepresentativeName: step6Data['customer_representative_name'] ?? '',
                technicianSignaturePath: step6Data['technician_signature_path'],
                customerSignaturePath: step6Data['customer_signature_path'],
                workPhotosPaths: List<String>.from(step6Data['work_photos_paths']),
              ));
              res.fold((l) => throw Exception("Step 6 failed"), (r) {});
            }
          }

          // If everything successful, delete from DB
          await db.deleteReport(id);

        } catch (e) {
          print("Failed to sync offline report $id: $e");
          // Will try again next time
        }
      }
    } catch (e) {
      print("Error in offline sync: $e");
    } finally {
      _isSyncing = false;
    }
  }
}
