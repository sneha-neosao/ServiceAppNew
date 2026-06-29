import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step2_model/service_work_report_step2_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep2AutoFillUsecase
    implements UseCase<ServiceWorkReportStep2Response, String> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep2AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep2Response>> call(
    String reportId,
  ) async {
    return await repository.serviceWorkReportStep2AutoFill(reportId);
  }
}
