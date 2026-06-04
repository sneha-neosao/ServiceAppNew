import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecalls_report_history_model/servicecalls_report_history_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportHistoryUsecase
    implements UseCase<ServiceCallReportResponse, NoParams> {
  final AuthRepositoryImpl repository;

  ServiceCallReportHistoryUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallReportResponse>> call(
      NoParams params) async {
    return await repository.getServiceCallsReportHistory();
  }
}
