import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/feedback_model/feedback_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetAmcCheckFeedbackUseCase {
  final Repository repository;

  GetAmcCheckFeedbackUseCase(this.repository);

  Future<Either<Failure, FeedbackResponse>> call(String amcVisitId) async {
    return await repository.getAmcCheckFeedback(amcVisitId);
  }
}
