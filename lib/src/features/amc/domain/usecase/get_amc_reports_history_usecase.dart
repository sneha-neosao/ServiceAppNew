import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_history_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class AmcReportsHistoryParams {
  final String? customerName;
  final String? siteName;
  final String? dateFrom;
  final String? dateTo;

  AmcReportsHistoryParams({
    this.customerName,
    this.siteName,
    this.dateFrom,
    this.dateTo,
  });
}

class GetAmcReportsHistoryUseCase implements UseCase<AmcHistoryResponse, AmcReportsHistoryParams> {
  final Repository repository;

  GetAmcReportsHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, AmcHistoryResponse>> call(AmcReportsHistoryParams params) async {
    return await repository.amcReportsHistory(params);
  }
}
