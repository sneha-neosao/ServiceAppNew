import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';

class CommissioningStep3AutofillUsecase
    implements
        UseCase<CommissioningStep3Response, CommissioningStep3AutofillParams> {
  final Repository _authRepository;

  const CommissioningStep3AutofillUsecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningStep3Response>> call(
    CommissioningStep3AutofillParams params,
  ) async {
    return await _authRepository.commissioning_report_step3_autofill(params);
  }
}

class CommissioningStep3AutofillParams extends Equatable {
  final String id;

  const CommissioningStep3AutofillParams(this.id);

  @override
  List<Object?> get props => [id];
}
