import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_assigned_technicians_response.dart';

class GetAmcAssignedTechniciansUsecase
    implements UseCase<AmcAssignedTechniciansResponse, String> {
  final Repository repository;

  GetAmcAssignedTechniciansUsecase(this.repository);

  @override
  Future<Either<Failure, AmcAssignedTechniciansResponse>> call(
      String params) async {
    return await repository.amcReportAssignedTechnicians(params);
  }
}
