import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart';

class CommissioningStep5AutofillUsecase implements UseCase<CommissioningReportStep5AutoFillResponse, CommissioningStep5AutofillParams> {
  final Repository _authRepository;

  const CommissioningStep5AutofillUsecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep5AutoFillResponse>> call(CommissioningStep5AutofillParams params) async {
    return await _authRepository.commissioning_report_step5_autofill(params);
  }
}

class CommissioningStep5AutofillParams extends Equatable {
  final String id;

  const CommissioningStep5AutofillParams(
    this.id,
  );

  @override
  List<Object?> get props => [
        id,
      ];
}
