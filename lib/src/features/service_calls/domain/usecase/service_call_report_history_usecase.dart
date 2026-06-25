import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecalls_report_history_model/servicecalls_report_history_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportHistoryParams {
  final String? customerId;
  final String? siteId;
  final String? date;
  final String? startDate;
  final String? endDate;
  final int? page;
  final int? pageSize;
  final String? search;
  final String? reportType;

  ServiceCallReportHistoryParams({
    this.customerId,
    this.siteId,
    this.date,
    this.startDate,
    this.endDate,
    this.page,
    this.pageSize,
    this.search,
    this.reportType,
  });
}

class ServiceCallReportHistoryUsecase
    implements UseCase<ServiceCallReportResponse, ServiceCallReportHistoryParams> {
  final AuthRepositoryImpl repository;

  ServiceCallReportHistoryUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallReportResponse>> call(
      ServiceCallReportHistoryParams params) async {
    return await repository.getServiceCallsReportHistory(params);
  }
}
