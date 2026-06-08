import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_list_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class AmcVisitsListUseCase implements UseCase<AmcVisitsListResponse, NoParams> {
  final Repository repository;

  AmcVisitsListUseCase(this.repository);

  @override
  Future<Either<Failure, AmcVisitsListResponse>> call(NoParams params) async {
    return await repository.technicianAmcs(params);
  }
}
