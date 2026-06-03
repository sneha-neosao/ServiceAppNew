import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step4_model/servicecall_report_step4_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep4AutoFillUsecase
    implements UseCase<ServiceCallStep4Response, String> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep4AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep4Response>> call(
      String params) async {
    return await repository.serviceCallReportStep4AutoFill(params);
  }
}
