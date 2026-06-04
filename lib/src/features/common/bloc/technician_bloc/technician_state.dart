part of 'technician_bloc.dart';

sealed class TechnicianState extends Equatable {
  const TechnicianState();
  @override
  List<Object?> get props => [];
}

class TechniciannitialState extends TechnicianState {}

/// States like loading, success and failure representing Technician fetching.

class TechnicianLoadingState extends TechnicianState {}

class TechnicianSuccessState extends TechnicianState {
  final TechnicianResponse data;

  const TechnicianSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class TechnicianFailureState extends TechnicianState {
  final String message;

  const TechnicianFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
