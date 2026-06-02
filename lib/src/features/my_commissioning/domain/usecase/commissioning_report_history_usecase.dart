import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_history_response.dart';

/// Use case for fetching the Commissioning Report History via API.
class CommissioningReportHistoryUseCase
    implements
        UseCase<CommissioningReportHistoryResponse,
            CommissioningReportHistoryParams> {
  final Repository _repository;
  const CommissioningReportHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, CommissioningReportHistoryResponse>> call(
    CommissioningReportHistoryParams params,
  ) async {
    final result = await _repository.commissioningReportHistory(params);
    return result;
  }
}

class CommissioningReportHistoryParams {
  final String? customerId;
  final String? siteId;
  final String? date;
  final String? startDate;
  final String? endDate;
  final String? search;
  final String? ordering;
  final int? page;
  final int? pageSize;

  const CommissioningReportHistoryParams({
    this.customerId,
    this.siteId,
    this.date,
    this.startDate,
    this.endDate,
    this.search,
    this.ordering,
    this.page,
    this.pageSize,
  });
}
