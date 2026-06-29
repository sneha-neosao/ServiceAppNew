
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/amc_report_model/delete_amc_report_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class DeleteAmcReportUsecase
    implements UseCase<DeleteAmcReportResponse, String> {
  final Repository repository;

  DeleteAmcReportUsecase(this.repository);

  @override
  Future<Either<Failure, DeleteAmcReportResponse>> call(String params) {
    return repository.deleteAmcReport(params);
  }
}
