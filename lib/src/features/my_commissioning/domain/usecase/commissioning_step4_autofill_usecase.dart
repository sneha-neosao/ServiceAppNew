import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';

class CommissioningStep4AutofillUsecase implements UseCase<CommissioningReportStep4AutoFillResponse, CommissioningStep4AutofillParams> {
  final Repository _authRepository;

  const CommissioningStep4AutofillUsecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep4AutoFillResponse>> call(CommissioningStep4AutofillParams params) async {
    return await _authRepository.commissioning_report_step4_autofill(params);
  }
}

class CommissioningStep4AutofillParams extends Equatable {
  final String id;

  const CommissioningStep4AutofillParams(
    this.id,
  );

  @override
  List<Object?> get props => [
        id,
      ];
}
