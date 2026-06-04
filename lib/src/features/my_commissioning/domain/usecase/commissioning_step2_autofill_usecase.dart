import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import '../../../../remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_autofill_response.dart';

/// Domain layer use case for fetching auto fill step 2 data

class CommissioningStep2AutofillUsecase
    implements
        UseCase<
          CommissioningReportStep2AutoFillResponse,
          CommissioningStep2AutofillParams
        > {
  final Repository _authRepository;
  const CommissioningStep2AutofillUsecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep2AutoFillResponse>> call(
    CommissioningStep2AutofillParams params,
  ) async {
    final result = await _authRepository.commissioning_report_step2_autofill(
      params,
    );

    return result;
  }
}

class CommissioningStep2AutofillParams extends Equatable {
  final String commissioning_report_id;

  const CommissioningStep2AutofillParams({
    required this.commissioning_report_id,
  });

  @override
  List<Object?> get props => [commissioning_report_id];
}
