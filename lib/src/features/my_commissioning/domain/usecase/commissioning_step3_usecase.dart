import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';

class CommissioningStep3Usecase implements UseCase<CommissioningStep3Response, CommissioningStep3Params> {
  final Repository _authRepository;

  const CommissioningStep3Usecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningStep3Response>> call(CommissioningStep3Params params) async {
    return await _authRepository.commissioning_report_step3(params);
  }
}

class CommissioningStep3Params extends Equatable {
  final String id;
  final bool isTechnicalNa;
  final TechnicalDetails? technicalDetails;

  const CommissioningStep3Params({
    required this.id,
    required this.isTechnicalNa,
    this.technicalDetails,
  });

  @override
  List<Object?> get props => [
    id,
    isTechnicalNa,
    technicalDetails,
  ];
}
