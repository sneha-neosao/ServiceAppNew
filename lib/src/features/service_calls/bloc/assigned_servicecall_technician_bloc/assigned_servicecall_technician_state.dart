import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/assigned_servicecall_technician_model/assigned_servicecall_technician_response.dart';

abstract class AssignedServicecallTechnicianState extends Equatable {
  const AssignedServicecallTechnicianState();

  @override
  List<Object?> get props => [];
}

class AssignedServicecallTechnicianInitialState
    extends AssignedServicecallTechnicianState {}

class AssignedServicecallTechnicianLoadingState
    extends AssignedServicecallTechnicianState {}

class AssignedServicecallTechnicianSuccessState
    extends AssignedServicecallTechnicianState {
  final AssignedServiceCallTechnicianResponse data;

  const AssignedServicecallTechnicianSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AssignedServicecallTechnicianFailureState
    extends AssignedServicecallTechnicianState {
  final String message;

  const AssignedServicecallTechnicianFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
