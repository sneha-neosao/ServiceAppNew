import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_details_response.dart';

/// Use case for fetching the Commissioning Report Details by ID via API.
class CommissioningReportDetailsUseCase {
  final Repository _repository;
  const CommissioningReportDetailsUseCase(this._repository);

  Future<Either<Failure, CommissioningDetailsResponse>> call(
    String reportId,
  ) async {
    final result = await _repository.commissioningReportDetails(reportId);
    return result;
  }
}
