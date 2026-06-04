import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/assigned_servicecall_technician_model/assigned_servicecall_technician_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class AssignedServicecallTechnicianUsecase
    implements
        UseCase<
          AssignedServiceCallTechnicianResponse,
          AssignedServicecallTechnicianParams
        > {
  final AuthRepositoryImpl repository;
  AssignedServicecallTechnicianUsecase(this.repository);

  @override
  Future<Either<Failure, AssignedServiceCallTechnicianResponse>> call(
    AssignedServicecallTechnicianParams params,
  ) async {
    return await repository.assignedServiceCallTechnicians(params.reportId);
  }
}

class AssignedServicecallTechnicianParams extends Equatable {
  final String reportId;
  const AssignedServicecallTechnicianParams(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
