import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step1_response.dart';

class GetAmcReportStep1AutofillUsecase
    implements UseCase<AmcReportStep1Response, String> {
  final Repository repository;

  GetAmcReportStep1AutofillUsecase(this.repository);

  @override
  Future<Either<Failure, AmcReportStep1Response>> call(String params) async {
    return await repository.amcReportStep1AutoFill(params);
  }
}
