import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/assign_technician_service_call_model/assign_technician_service_calls_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class AssignTechnicianServiceCallsParams extends Equatable {
  final String complaintId;
  final List<String> technicianIds;

  const AssignTechnicianServiceCallsParams({
    required this.complaintId,
    required this.technicianIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'complaint_id': complaintId,
      'technician_ids': technicianIds,
    };
  }

  @override
  List<Object?> get props => [complaintId, technicianIds];
}

class AssignTechnicianServiceCallsUsecase
    implements UseCase<AssignTechnicianServiceCallsResponse, AssignTechnicianServiceCallsParams> {
  final Repository repository;

  AssignTechnicianServiceCallsUsecase(this.repository);

  @override
  Future<Either<Failure, AssignTechnicianServiceCallsResponse>> call(
      AssignTechnicianServiceCallsParams params) async {
    return await repository.assignTechnicianServiceCalls(params);
  }
}
