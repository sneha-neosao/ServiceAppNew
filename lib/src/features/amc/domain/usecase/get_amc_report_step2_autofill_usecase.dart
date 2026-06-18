import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step2_response.dart';

class GetAmcReportStep2AutofillUsecase
    implements UseCase<AmcReportStep2Response, String> {
  final Repository repository;

  GetAmcReportStep2AutofillUsecase(this.repository);

  @override
  Future<Either<Failure, AmcReportStep2Response>> call(String params) async {
    return await repository.amcReportStep2AutoFill(params);
  }
}
