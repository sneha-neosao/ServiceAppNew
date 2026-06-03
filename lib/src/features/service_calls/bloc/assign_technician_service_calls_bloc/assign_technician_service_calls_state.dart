import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/assign_technician_service_call_model/assign_technician_service_calls_response.dart';

abstract class AssignTechnicianServiceCallsState extends Equatable {
  const AssignTechnicianServiceCallsState();

  @override
  List<Object?> get props => [];
}

class AssignTechnicianServiceCallsInitialState
    extends AssignTechnicianServiceCallsState {}

class AssignTechnicianServiceCallsLoadingState
    extends AssignTechnicianServiceCallsState {}

class AssignTechnicianServiceCallsSuccessState
    extends AssignTechnicianServiceCallsState {
  final AssignTechnicianServiceCallsResponse data;

  const AssignTechnicianServiceCallsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AssignTechnicianServiceCallsFailureState
    extends AssignTechnicianServiceCallsState {
  final String message;

  const AssignTechnicianServiceCallsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
