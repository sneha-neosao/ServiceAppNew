import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';

class CommissioningStep6AutofillUsecase
    implements
        UseCase<
          CommissioningReportStep6AutoFillResponse,
          CommissioningStep6AutofillParams
        > {
  final Repository _authRepository;

  const CommissioningStep6AutofillUsecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep6AutoFillResponse>> call(
    CommissioningStep6AutofillParams params,
  ) async {
    return await _authRepository.commissioning_report_step6_autofill(params);
  }
}

class CommissioningStep6AutofillParams extends Equatable {
  final String id;

  const CommissioningStep6AutofillParams(this.id);

  @override
  List<Object?> get props => [id];
}
