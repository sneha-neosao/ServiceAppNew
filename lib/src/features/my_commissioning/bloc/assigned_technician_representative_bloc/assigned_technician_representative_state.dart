import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/assigned_technician_representative_model/assigned_technician_representative_response.dart';

sealed class AssignedTechnicianRepresentativeState extends Equatable {
  const AssignedTechnicianRepresentativeState();

  @override
  List<Object?> get props => [];
}

final class AssignedTechnicianRepresentativeInitialState extends AssignedTechnicianRepresentativeState {}

class AssignedTechnicianRepresentativeLoadingState extends AssignedTechnicianRepresentativeState {}

class AssignedTechnicianRepresentativeSuccessState extends AssignedTechnicianRepresentativeState {
  final AssignedTechnicianResponse data;

  const AssignedTechnicianRepresentativeSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AssignedTechnicianRepresentativeFailureState extends AssignedTechnicianRepresentativeState {
  final String message;

  const AssignedTechnicianRepresentativeFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
