import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step6_autofill_model/servicecall_report_step6_autofill_response.dart';

class ServiceCallReportStep6AutoFillUsecase
    implements UseCase<ServiceCallReportStep6AutoFillResponse, String> {
  final Repository _authRepository;

  const ServiceCallReportStep6AutoFillUsecase(this._authRepository);

  @override
  Future<Either<Failure, ServiceCallReportStep6AutoFillResponse>> call(
    String reportId,
  ) async {
    return await _authRepository.serviceCallReportStep6AutoFill(reportId);
  }
}
