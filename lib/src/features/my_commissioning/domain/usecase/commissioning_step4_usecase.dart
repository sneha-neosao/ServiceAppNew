import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';

class CommissioningStep4Usecase
    implements
        UseCase<
          CommissioningReportStep4AutoFillResponse,
          CommissioningStep4Params
        > {
  final Repository _authRepository;

  const CommissioningStep4Usecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep4AutoFillResponse>> call(
    CommissioningStep4Params params,
  ) async {
    return await _authRepository.commissioning_report_step4(params);
  }
}

class CommissioningStep4Params extends Equatable {
  final String id;
  final List<SavedDescription> descriptions;

  const CommissioningStep4Params({
    required this.id,
    required this.descriptions,
  });

  @override
  List<Object?> get props => [id, descriptions];
}
