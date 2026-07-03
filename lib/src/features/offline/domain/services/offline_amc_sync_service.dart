import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/database/offline_amc_reports_db.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/utils/logger.dart';

import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step1_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step2_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step3_usecase.dart';

class OfflineAmcSyncService {
  final PostAmcReportStep1Usecase _amcStep1;
  final PostAmcReportStep2Usecase _amcStep2;
  final PostAmcReportStep3UseCase _amcStep3;

  OfflineAmcSyncService(
    this._amcStep1,
    this._amcStep2,
    this._amcStep3,
  );

  Future<Either<Failure, bool>> syncReport(String reportId) async {
    try {
      final report = await OfflineAmcReportsDb.instance.getReport(reportId);
      if (report == null) return Left(ServerFailure('Local AMC report not found.'));

      final visitId = report['commissioning_work_id'] as String;
      String currentServerId = report['report_id'] as String;

      // STEP 1 - Skipped as requested: start syncing from step 2
      /*
      if (report['step1'] != null) {
        final step1Data = jsonDecode(report['step1'] as String);
        final rawTechs = List<Map<String, dynamic>>.from(step1Data['technicianIds'] ?? []);
        
        final res = await _amcStep1.call(PostAmcReportStep1Params(
          amcVisitId: visitId,
          amcReportId: currentServerId.isEmpty || currentServerId == visitId ? null : currentServerId,
          technicianIds: rawTechs,
          memberPresentsCustomerSide: step1Data['memberPresentsCustomerSide'] ?? '',
          agenda: step1Data['agenda'] ?? '',
        ));
        
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
        
        final step1Resp = res.getRight().toNullable()!;
        final newReportId = step1Resp.data.id;
        
        if (newReportId.isNotEmpty && newReportId != currentServerId) {
          currentServerId = newReportId;
          // Update database with the new server report ID so subsequent steps can use it
          await OfflineAmcReportsDb.instance.updateAssignId(visitId, newReportId, report['assign_id'] ?? '');
        }
      }
      */

      // STEP 2
      if (report['step2'] != null) {
        final step2Data = jsonDecode(report['step2'] as String);
        
        final res = await _amcStep2.call(PostAmcReportStep2Params(
          id: currentServerId,
          isMechanicalChecklistNa: step2Data['isMechanicalChecklistNa'] == true,
          isPipelineHydraulicChecklistNa: step2Data['isPipelineHydraulicChecklistNa'] == true,
          isElectricalChecklistNa: step2Data['isElectricalChecklistNa'] == true,
          operationChecklistNa: step2Data['operationChecklistNa'] == true,
          mechanicalChecklist: step2Data['mechanicalChecklist'] ?? '',
          pipelineHydraulicChecklist: step2Data['pipelineHydraulicChecklist'] ?? '',
          electricalChecklist: step2Data['electricalChecklist'] ?? '',
          operationChecklist: step2Data['operationChecklist'] ?? '',
        ));
        
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      // STEP 3
      if (report['step3'] != null) {
        final step3Data = jsonDecode(report['step3'] as String);
        
        final res = await _amcStep3.call(PostAmcReportStep3Params(
          id: currentServerId,
          technicianRemarks: step3Data['technicianRemarks'] ?? '',
          customerRemarks: step3Data['customerRemarks'] ?? '',
          workPhotos: (step3Data['workPhotosPaths'] as List? ?? []).map((path) => File(path)).toList(),
          technicianRepresentative: step3Data['technicianRepresentative'] ?? '',
          technicianSignature: step3Data['technicianSignaturePath'] != null ? File(step3Data['technicianSignaturePath']) : null,
          customerRepresentativeName: step3Data['customerRepresentativeName'] ?? '',
          customerSignature: step3Data['customerSignaturePath'] != null ? File(step3Data['customerSignaturePath']) : null,
        ));
        
        if (res.isLeft()) return Left(res.getLeft().toNullable()!);
      }

      await OfflineAmcReportsDb.instance.deleteReport(currentServerId.isNotEmpty ? currentServerId : reportId);
      return const Right(true);
    } catch (e, st) {
      logger.e('Error syncing offline AMC report: $e\n$st');
      return Left(ServerFailure('Sync failed: $e'));
    }
  }
}
