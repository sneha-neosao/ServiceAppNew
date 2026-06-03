import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step3_model/servicecall_report_step3_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep3AutoFillUsecase
    implements UseCase<ServiceCallStep3Response, String> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep3AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep3Response>> call(
      String params) async {
    return await repository.serviceCallReportStep3AutoFill(params);
  }
}
