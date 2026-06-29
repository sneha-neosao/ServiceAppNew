import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/delete_service_work_report_model/delete_service_work_report_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class DeleteServiceWorkReportUsecase implements UseCase<DeleteServiceWorkReportResponse, String> {
  final AuthRepositoryImpl repository;

  DeleteServiceWorkReportUsecase(this.repository);

  @override
  Future<Either<Failure, DeleteServiceWorkReportResponse>> call(String reportId) async {
    return await repository.deleteServiceWorkReport(reportId);
  }
}
