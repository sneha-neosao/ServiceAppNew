import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_visit_complete_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class PostAmcVisitCompleteUseCase {
  final Repository repository;

  PostAmcVisitCompleteUseCase(this.repository);

  Future<Either<Failure, AmcVisitCompleteResponse>> call(String visitId) async {
    return await repository.postAmcVisitComplete(visitId);
  }
}
