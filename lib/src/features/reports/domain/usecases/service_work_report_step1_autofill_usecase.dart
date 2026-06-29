import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step1_model/service_work_report_step1_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep1AutoFillUsecase
    implements UseCase<ServiceWorkReportStep1Response, String> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep1AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep1Response>> call(
    String complaintId,
  ) async {
    return await repository.serviceWorkReportStep1AutoFill(complaintId);
  }
}
