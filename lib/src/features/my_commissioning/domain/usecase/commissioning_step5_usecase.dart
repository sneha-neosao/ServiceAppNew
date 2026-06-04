import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart';

class CommissioningStep5Usecase
    implements
        UseCase<
          CommissioningReportStep5AutoFillResponse,
          CommissioningStep5Params
        > {
  final Repository _authRepository;

  const CommissioningStep5Usecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep5AutoFillResponse>> call(
    CommissioningStep5Params params,
  ) async {
    return await _authRepository.commissioning_report_step5(params);
  }
}

class CommissioningStep5Params extends Equatable {
  final String id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<SavedChecklist> checklistItems;

  const CommissioningStep5Params({
    required this.id,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.checklistItems,
  });

  @override
  List<Object?> get props => [
    id,
    isMechanicalChecklistNa,
    isPipelineChecklistNa,
    isElectricalChecklistNa,
    checklistItems,
  ];
}
