import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/database/offline_commissioning_db.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/utils/logger.dart';

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
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart'
    hide SavedDescription;

class OfflineSyncService {
  final CommissioningStep1Usecase _commStep1;
  final CommissioningStep2Usecase _commStep2;
  final CommissioningStep3Usecase _commStep3;
  final CommissioningStep4Usecase _commStep4;
  final CommissioningStep5Usecase _commStep5;
  final CommissioningStep6Usecase _commStep6;

  final ServiceCallReportStep1Usecase _serviceStep1;
  final ServiceCallReportStep2Usecase _serviceStep2;
  final ServiceCallReportStep3Usecase _serviceStep3;
  final ServiceCallReportStep4Usecase _serviceStep4;
  final ServiceCallReportStep5Usecase _serviceStep5;
  final ServiceCallReportStep6Usecase _serviceStep6;

  OfflineSyncService(
    this._commStep1,
    this._commStep2,
    this._commStep3,
    this._commStep4,
    this._commStep5,
    this._commStep6,
    this._serviceStep1,
    this._serviceStep2,
    this._serviceStep3,
    this._serviceStep4,
    this._serviceStep5,
    this._serviceStep6,
  );

  Future<Either<Failure, bool>> syncReport(String reportId) async {
    try {
      final report = await OfflineCommissioningDb.instance.getReport(reportId);
      if (report == null) return Left(ServerFailure('Local report not found.'));

      final commissioningWorkId = report['commissioning_work_id'] as String;
      final isServiceReport = (report['is_service_report'] ?? 0) == 1;
      // Step 1 is already submitted when the report was first created.
      // Use the stored report_id directly as the server ID for steps 2–6.
      String currentServerId = reportId;



      // STEP 2
      if (report['step2'] != null) {
        final step2Data = jsonDecode(report['step2'] as String);
        if (isServiceReport) {
          final res = await _serviceStep2.call(ServiceCallReportStep2Params(
            id: currentServerId,
            memberPresentsCustomerSide: step2Data['member_presents_customer_side'] ?? '',
            agenda: step2Data['agenda'] ?? '',
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        } else {
          List<String> memberPresents = [];
          final rawMember = step2Data['member_presents_customer_side'];
          if (rawMember is String) {
            memberPresents = rawMember.isEmpty ? [] : rawMember.split(', ');
          } else if (rawMember is List) {
            memberPresents = List<String>.from(rawMember);
          }

          final res = await _commStep2.call(CommissioningStep2Params(
            id: currentServerId,
            memberPresentsCustomerSide: memberPresents,
            agenda: step2Data['agenda'] ?? '',
            warrantyPeriodYears: step2Data['warranty_period_years'] ?? 1,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        }
      }

      // STEP 3
      if (report['step3'] != null) {
        final step3Data = jsonDecode(report['step3'] as String);
        TechnicalDetails? techDetails;
        if (step3Data['technicalDetails'] != null) {
          techDetails = TechnicalDetails.fromJson(Map<String, dynamic>.from(step3Data['technicalDetails']));
        }
        if (isServiceReport) {
          final res = await _serviceStep3.call(ServiceCallReportStep3Params(
            id: currentServerId,
            isTechnicalNa: step3Data['isTechnicalNa'] == true,
            technicalDetails: techDetails,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        } else {
          final res = await _commStep3.call(CommissioningStep3Params(
            id: currentServerId,
            isTechnicalNa: step3Data['isTechnicalNa'] == true,
            technicalDetails: techDetails,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        }
      }

      // STEP 4
      if (report['step4'] != null) {
        final step4Data = jsonDecode(report['step4'] as String);
        final rawDescriptions = List<Map<String, dynamic>>.from(step4Data['descriptions'] ?? []);
        if (isServiceReport) {
          final res = await _serviceStep4.call(ServiceCallReportStep4Params(
            reportId: currentServerId,
            descriptions: rawDescriptions,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        } else {
          final descriptions = rawDescriptions
              .map<SavedDescription>((e) => SavedDescription(srNo: e['sr_no'], description: e['description']))
              .toList();
          final res = await _commStep4.call(CommissioningStep4Params(
            id: currentServerId,
            descriptions: descriptions,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        }
      }

      // STEP 5
      if (report['step5'] != null) {
        final step5Data = jsonDecode(report['step5'] as String);
        final rawChecklists = List<Map<String, dynamic>>.from(step5Data['savedChecklists'] ?? []);
        if (isServiceReport) {
          final res = await _serviceStep5.call(ServiceCallReportStep5Params(
            reportId: currentServerId,
            isMechanicalChecklistNa: step5Data['isMechanicalChecklistNa'] == true,
            isPipelineChecklistNa: step5Data['isPipelineChecklistNa'] == true,
            isElectricalChecklistNa: step5Data['isElectricalChecklistNa'] == true,
            checklistItems: rawChecklists,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        } else {
          final checklists = rawChecklists.map((e) {
            return SavedChecklist(
              id: "",
              checkType: e['check_type'],
              keyChecklist: e['key_checklist'],
              valueChecklist: e['value_checklist'],
              photo: e['photo'],
              video: e['video'],
            );
          }).toList();
          final res = await _commStep5.call(CommissioningStep5Params(
            id: currentServerId,
            isMechanicalChecklistNa: step5Data['isMechanicalChecklistNa'] == true,
            isPipelineChecklistNa: step5Data['isPipelineChecklistNa'] == true,
            isElectricalChecklistNa: step5Data['isElectricalChecklistNa'] == true,
            checklistItems: checklists,
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        }
      }

      // STEP 6
      if (report['step6'] != null) {
        final step6Data = jsonDecode(report['step6'] as String);
        if (isServiceReport) {
          final res = await _serviceStep6.call(ServiceCallReportStep6Params(
            id: currentServerId,
            technicianRemarks: step6Data['technicianRemarks'] ?? '',
            customerRemarks: step6Data['customerRemarks'] ?? '',
            technicianRepresentative: step6Data['technicianRepresentative'] ?? '',
            customerRepresentativeName: step6Data['customerRepresentativeName'] ?? '',
            technicianSignaturePath: step6Data['technicianSignaturePath'],
            customerSignaturePath: step6Data['customerSignaturePath'],
            workPhotosPaths: List<String>.from(step6Data['workPhotosPaths'] ?? []),
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        } else {
          final res = await _commStep6.call(CommissioningStep6Params(
            id: currentServerId,
            assignId: step6Data['assignId'] ?? report['assign_id']?.toString(),
            technicianRemarks: step6Data['technicianRemarks'] ?? '',
            customerRemarks: step6Data['customerRemarks'] ?? '',
            technicianRepresentative: step6Data['technicianRepresentative'] ?? '',
            customerRepresentativeName: step6Data['customerRepresentativeName'] ?? '',
            technicianSignaturePath: step6Data['technicianSignaturePath'],
            customerSignaturePath: step6Data['customerSignaturePath'],
            workPhotosPaths: List<String>.from(step6Data['workPhotosPaths'] ?? []),
          ));
          if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        }
      }

      await OfflineCommissioningDb.instance.deleteReport(reportId);
      return const Right(true);
    } catch (e, st) {
      logger.e('Error syncing offline report: $e\n$st');
      return Left(ServerFailure('Sync failed: $e'));
    }
  }
}
