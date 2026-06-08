import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_reports_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class AmcVisitReportsUsecase implements UseCase<AmcVisitReportsResponse, String> {
  final Repository repository;

  AmcVisitReportsUsecase(this.repository);

  @override
  Future<Either<Failure, AmcVisitReportsResponse>> call(String params) async {
    return await repository.amcVisitReports(params);
  }
}
