import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/database/offline_commissioning_db.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/utils/logger.dart';

import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step2_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step3_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step4_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step5_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step6_usecase.dart';

import 'package:service_app/src/remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart'
    hide SavedDescription;

class OfflineSyncService {
  final CommissioningStep2Usecase _step2Usecase;
  final CommissioningStep3Usecase _step3Usecase;
  final CommissioningStep4Usecase _step4Usecase;
  final CommissioningStep5Usecase _step5Usecase;
  final CommissioningStep6Usecase _step6Usecase;

  OfflineSyncService(
    this._step2Usecase,
    this._step3Usecase,
    this._step4Usecase,
    this._step5Usecase,
    this._step6Usecase,
  );

  /// Synchronizes a specific commissioning report sequentially from step 2 to 6.
  /// Returns Right(true) if completely synced, or Left(Failure) if any step fails.
  Future<Either<Failure, bool>> syncReport(String reportId) async {
    try {
      final report = await OfflineCommissioningDb.instance.getReport(reportId);
      if (report == null) {
        return Left(ServerFailure('Local report not found.'));
      }

      // Step 2
      if (report['step2'] != null) {
        final step2Data =
            jsonDecode(report['step2'] as String) as Map<String, dynamic>;
        logger.i('Syncing Step 2 for report $reportId');

        List<String> memberPresents = [];
        final memberData = step2Data['member_presents_customer_side'];
        if (memberData is String) {
          memberPresents = memberData.isEmpty ? [] : memberData.split(', ').toList();
        } else if (memberData is List) {
          memberPresents = memberData.map((e) => e.toString()).toList();
        }

        final params = CommissioningStep2Params(
          id: reportId,
          warrantyPeriodYears:
              int.tryParse(
                step2Data['warranty_period_years']?.toString() ?? '',
              ) ??
              0,
          memberPresentsCustomerSide: memberPresents,
          agenda: step2Data['agenda']?.toString() ?? '',
        );

        final result = await _step2Usecase.call(params);
        if (result.isLeft()) return Left(result.getLeft().toNullable()!);
      }

      // Step 3
      if (report['step3'] != null) {
        final step3Data =
            jsonDecode(report['step3'] as String) as Map<String, dynamic>;
        logger.i('Syncing Step 3 for report $reportId');

        TechnicalDetails? techDetails;
        if (step3Data['technicalDetails'] != null) {
          techDetails = TechnicalDetails.fromJson(
            Map<String, dynamic>.from(step3Data['technicalDetails'] as Map),
          );
        }

        final params = CommissioningStep3Params(
          id: reportId,
          isTechnicalNa: step3Data['isTechnicalNa'] == true,
          technicalDetails: techDetails,
        );

        final result = await _step3Usecase.call(params);
        if (result.isLeft()) return Left(result.getLeft().toNullable()!);
      }

      // Step 4
      if (report['step4'] != null) {
        final step4Data =
            jsonDecode(report['step4'] as String) as Map<String, dynamic>;
        logger.i('Syncing Step 4 for report $reportId');

        List<SavedDescription> descriptions = [];
        if (step4Data['descriptions'] != null) {
          final list = step4Data['descriptions'] as List<dynamic>;
          descriptions = list
              .map(
                (e) => SavedDescription.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        }

        final params = CommissioningStep4Params(
          id: reportId,
          descriptions: descriptions,
        );

        final result = await _step4Usecase.call(params);
        if (result.isLeft()) return Left(result.getLeft().toNullable()!);
      }

      // Step 5
      if (report['step5'] != null) {
        final step5Data =
            jsonDecode(report['step5'] as String) as Map<String, dynamic>;
        logger.i('Syncing Step 5 for report $reportId');

        List<SavedChecklist> checklists = [];
        if (step5Data['savedChecklists'] != null) {
          final list = step5Data['savedChecklists'] as List<dynamic>;
          checklists = list
              .map(
                (e) => SavedChecklist.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        }

        final params = CommissioningStep5Params(
          id: reportId,
          isMechanicalChecklistNa: step5Data['isMechanicalChecklistNa'] == true,
          isPipelineChecklistNa: step5Data['isPipelineChecklistNa'] == true,
          isElectricalChecklistNa: step5Data['isElectricalChecklistNa'] == true,
          checklistItems: checklists,
        );

        final result = await _step5Usecase.call(params);
        if (result.isLeft()) return Left(result.getLeft().toNullable()!);
      }

      // Step 6
      if (report['step6'] != null) {
        final step6Data =
            jsonDecode(report['step6'] as String) as Map<String, dynamic>;
        logger.i('Syncing Step 6 for report $reportId');

        List<String> photos = [];
        if (step6Data['workPhotosPaths'] != null) {
          photos = (step6Data['workPhotosPaths'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
        }

        final params = CommissioningStep6Params(
          id: reportId,
          assignId: report['assign_id']?.toString(),
          technicianRemarks: step6Data['technicianRemarks']?.toString() ?? '',
          customerRemarks: step6Data['customerRemarks']?.toString() ?? '',
          technicianRepresentative:
              step6Data['technicianRepresentative']?.toString() ?? '',
          customerRepresentativeName:
              step6Data['customerRepresentativeName']?.toString() ?? '',
          technicianSignaturePath: step6Data['technicianSignaturePath']
              ?.toString(),
          customerSignaturePath: step6Data['customerSignaturePath']?.toString(),
          workPhotosPaths: photos,
        );

        final result = await _step6Usecase.call(params);
        if (result.isLeft()) return Left(result.getLeft().toNullable()!);
      }

      // If we got here, everything succeeded (or some steps were skipped but nothing failed)
      // We keep the local report but mark it as fully synced.
      await OfflineCommissioningDb.instance.updateSyncedStatus(reportId, true);

      return const Right(true);
    } catch (e, st) {
      logger.e('Error syncing offline report: $e\n$st');
      return Left(ServerFailure('Sync failed: $e'));
    }
  }
}
