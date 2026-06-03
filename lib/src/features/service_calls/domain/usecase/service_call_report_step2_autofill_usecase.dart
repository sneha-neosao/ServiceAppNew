import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step2_model/servicecall_report_step2_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep2AutoFillUsecase
    implements UseCase<ServiceCallStep2Response, String> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep2AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep2Response>> call(String params) async {
    return await repository.serviceCallReportStep2AutoFill(params);
  }
}
