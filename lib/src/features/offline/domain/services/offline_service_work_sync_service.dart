import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/database/offline_service_work_reports_db.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/core/session/session_manager.dart';

import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step1_usecase.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step2_usecase.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step3_usecase.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step4_usecase.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_technicians_usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';

class OfflineServiceWorkSyncService {
  final ServiceWorkReportStep1Usecase _step1;
  final ServiceWorkReportStep2Usecase _step2;
  final ServiceWorkReportStep3Usecase _step3;
  final ServiceWorkReportStep4Usecase _step4;
  final ServiceWorkReportTechniciansUsecase _techsUsecase;

  OfflineServiceWorkSyncService(
    this._step1,
    this._step2,
    this._step3,
    this._step4,
    this._techsUsecase,
  );

  Future<Either<Failure, bool>> syncReport(String reportId) async {
    try {
      final report = await OfflineServiceWorkReportsDb.instance.getReport(reportId);
      if (report == null) return Left(ServerFailure('Local service work report not found.'));

      final complaintId = report['commissioning_work_id'] as String;
      String currentServerId = report['report_id'] as String;

      // STEP 1
      /*
      if (report['step1'] != null) {
        final step1Data = jsonDecode(report['step1'] as String);
        final rawTechs = List<Map<String, dynamic>>.from(step1Data['technicianIds'] ?? []);
        final formattedTechs = rawTechs.map((e) => Map<String, String>.from(e.map((k, v) => MapEntry(k, v.toString())))).toList();

        final res = await _step1.call(ServiceWorkReportStep1Params(
          customerId: step1Data['customerId'] ?? '',
          siteId: step1Data['siteId'] ?? '',
          technicianIds: formattedTechs,
          memberPresentsCustomerSide: step1Data['memberPresentsCustomerSide'] ?? '',
          agenda: step1Data['agenda'] ?? '',
          complaintId: complaintId.isEmpty || complaintId == reportId ? null : complaintId,
        ));

        if (res.isLeft()) return Left(res.getLeft().toNullable()!);

        final step1Resp = res.getRight().toNullable()!;
        final newReportId = step1Resp.data.id;

        if (newReportId.isNotEmpty && newReportId != currentServerId) {
          currentServerId = newReportId;
          await OfflineServiceWorkReportsDb.instance.updateAssignId(complaintId, newReportId, report['assign_id'] ?? '');
        }

        // Call ServiceWorkReportTechniciansUsecase to fetch assigned technician list and resolve/save assignId
        final techRes = await _techsUsecase.call(ServiceWorkReportTechniciansParams(newReportId));
        if (techRes.isRight()) {
          final techData = techRes.getRight().toNullable()!;
          final session = await SessionManager.getUserSession();
          if (session != null && session.technician != null) {
            final loggedInId = session.technician!.id.toString();
            try {
              final match = techData.data.firstWhere((t) => t.technicianId.toString() == loggedInId);
              await OfflineServiceWorkReportsDb.instance.updateAssignId(complaintId, newReportId, match.assignId);
            } catch (_) {}
          }
        }
      }
      */

      // STEP 2
      if (report['step2'] != null) {
        final step2Data = jsonDecode(report['step2'] as String);
        final rawDescriptions = List<Map<String, dynamic>>.from(step2Data['descriptions'] ?? []);

        final res = await _step2.call(ServiceWorkReportStep2Params(
          id: currentServerId,
          isTechnicalNa: step2Data['isTechnicalNa'] == true,
          technicalDetails: step2Data['technicalDetails'] ?? '',
          descriptions: rawDescriptions,
        ));

        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 3
      if (report['step3'] != null) {
        final step3Data = jsonDecode(report['step3'] as String);
        final rawChecklists = List<Map<String, dynamic>>.from(step3Data['checklistItems'] ?? []);
        final formattedChecklist = rawChecklists.map((e) => ServiceWorkChecklistItem(
          checkType: e['check_type']?.toString() ?? '',
          keyChecklist: e['key_checklist']?.toString() ?? '',
          valueChecklist: e['value_checklist']?.toString() ?? '',
          photo: e['photo']?.toString(),
          video: e['video']?.toString(),
          existingPhotoUrl: e['existing_photo_url']?.toString(),
          existingVideoUrl: e['existing_video_url']?.toString(),
        )).toList();

        final res = await _step3.call(ServiceWorkReportStep3Params(
          id: currentServerId,
          isMechanicalChecklistNa: step3Data['isMechanicalChecklistNa'] == true,
          isPipelineChecklistNa: step3Data['isPipelineChecklistNa'] == true,
          isElectricalChecklistNa: step3Data['isElectricalChecklistNa'] == true,
          checklistItems: formattedChecklist,
        ));

        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 4
      if (report['step4'] != null) {
        final step4Data = jsonDecode(report['step4'] as String);

        final res = await _step4.call(ServiceWorkReportStep4Params(
          id: currentServerId,
          customerRepresentativeName: step4Data['customerRepresentativeName'] ?? '',
          customerRemarks: step4Data['customerRemarks'] ?? '',
          technicianRemarks: step4Data['technicianRemarks'] ?? '',
          technicianRepresentative: step4Data['technicianRepresentative'] ?? '',
          qrCodeUrl: step4Data['qrCodeUrl'] ?? '',
          workPhotosPaths: List<String>.from(step4Data['workPhotosPaths'] ?? []),
          customerSignaturePath: step4Data['customerSignaturePath'],
          technicianSignaturePath: step4Data['technicianSignaturePath'],
        ));

        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      await OfflineServiceWorkReportsDb.instance.deleteReport(currentServerId.isNotEmpty ? currentServerId : reportId);
      return const Right(true);
    } catch (e, st) {
      logger.e('Error syncing offline service work report: $e\n$st');
      return Left(ServerFailure('Sync failed: $e'));
    }
  }
}
