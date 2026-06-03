import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step1_model/servicecall_report_step1_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep1AutoFillUsecase
    implements UseCase<ServiceCallStep1Response, String> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep1AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep1Response>> call(String params) async {
    return await repository.serviceCallReportStep1AutoFill(params);
  }
}
