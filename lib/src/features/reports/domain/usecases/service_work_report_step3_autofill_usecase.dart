import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep3AutoFillUsecase
    implements UseCase<ServiceWorkReportStep3Response, String> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep3AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep3Response>> call(
    String reportId,
  ) async {
    return await repository.serviceWorkReportStep3AutoFill(reportId);
  }
}
