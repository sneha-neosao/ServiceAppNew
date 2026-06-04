import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/feedback_model/feedback_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class CommissioningReportCheckFeedbackUsecase
    implements UseCase<FeedbackResponse, String> {
  final Repository repository;

  CommissioningReportCheckFeedbackUsecase(this.repository);

  @override
  Future<Either<Failure, FeedbackResponse>> call(String reportId) async {
    return await repository.getCommissioningReportFeedback(reportId);
  }
}
