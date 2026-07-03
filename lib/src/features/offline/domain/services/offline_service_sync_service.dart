import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/database/offline_service_reports_db.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/utils/logger.dart';

import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step4_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step5_usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step6_usecase.dart';

import 'package:service_app/src/remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';

class OfflineServiceSyncService {
  final ServiceCallReportStep1Usecase _serviceStep1;
  final ServiceCallReportStep2Usecase _serviceStep2;
  final ServiceCallReportStep3Usecase _serviceStep3;
  final ServiceCallReportStep4Usecase _serviceStep4;
  final ServiceCallReportStep5Usecase _serviceStep5;
  final ServiceCallReportStep6Usecase _serviceStep6;

  OfflineServiceSyncService(
    this._serviceStep1,
    this._serviceStep2,
    this._serviceStep3,
    this._serviceStep4,
    this._serviceStep5,
    this._serviceStep6,
  );

  Future<Either<Failure, String?>> syncReport(String reportId) async {
    try {
      final report = await OfflineServiceReportsDb.instance.getReport(reportId);
      if (report == null) return Left(ServerFailure('Local service report not found.'));

      final commissioningWorkId = report['commissioning_work_id'] as String;
      String currentServerId = reportId;

      // STEP 2
      if (report['step2'] != null) {
        final step2Data = jsonDecode(report['step2'] as String);
        final res = await _serviceStep2.call(ServiceCallReportStep2Params(
          id: currentServerId,
          memberPresentsCustomerSide: step2Data['member_presents_customer_side'] ?? '',
          agenda: step2Data['agenda'] ?? '',
        ));
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 3
      if (report['step3'] != null) {
        final step3Data = jsonDecode(report['step3'] as String);
        TechnicalDetails? techDetails;
        if (step3Data['technicalDetails'] != null) {
          techDetails = TechnicalDetails.fromJson(Map<String, dynamic>.from(step3Data['technicalDetails']));
        }
        final res = await _serviceStep3.call(ServiceCallReportStep3Params(
          id: currentServerId,
          isTechnicalNa: step3Data['isTechnicalNa'] == true,
          technicalDetails: techDetails,
        ));
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 4
      if (report['step4'] != null) {
        final step4Data = jsonDecode(report['step4'] as String);
        final rawDescriptions = List<Map<String, dynamic>>.from(step4Data['descriptions'] ?? []);
        final res = await _serviceStep4.call(ServiceCallReportStep4Params(
          reportId: currentServerId,
          descriptions: rawDescriptions,
        ));
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 5
      if (report['step5'] != null) {
        final step5Data = jsonDecode(report['step5'] as String);
        final rawChecklists = List<Map<String, dynamic>>.from(step5Data['savedChecklists'] ?? []);
        final res = await _serviceStep5.call(ServiceCallReportStep5Params(
          reportId: currentServerId,
          isMechanicalChecklistNa: step5Data['isMechanicalChecklistNa'] == true,
          isPipelineChecklistNa: step5Data['isPipelineChecklistNa'] == true,
          isElectricalChecklistNa: step5Data['isElectricalChecklistNa'] == true,
          checklistItems: rawChecklists,
        ));
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 6
      if (report['step6'] != null) {
        final step6Data = jsonDecode(report['step6'] as String);
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
        final qrCodeImage = res.getRight().toNullable()?.data.qrCodeImage;
        await OfflineServiceReportsDb.instance.deleteReport(reportId);
        return Right(qrCodeImage);
      }

      await OfflineServiceReportsDb.instance.deleteReport(reportId);
      return const Right(null);
    } catch (e, st) {
      logger.e('Error syncing offline service report: $e\n$st');
      return Left(ServerFailure('Sync failed: $e'));
    }
  }
}
