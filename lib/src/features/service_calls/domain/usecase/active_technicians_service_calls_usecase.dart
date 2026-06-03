import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ActiveTechniciansServiceCallsUsecase
    implements UseCase<ActiveTechniciansServiceCallsResponse, NoParams> {
  final Repository repository;

  ActiveTechniciansServiceCallsUsecase(this.repository);

  @override
  Future<Either<Failure, ActiveTechniciansServiceCallsResponse>> call(
      NoParams params) async {
    return await repository.activeTechniciansServiceCalls(params);
  }
}
