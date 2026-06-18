import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_history_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetAmcReportsHistoryUseCase implements UseCase<AmcHistoryResponse, NoParams> {
  final Repository repository;

  GetAmcReportsHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, AmcHistoryResponse>> call(NoParams params) async {
    return await repository.amcReportsHistory();
  }
}
