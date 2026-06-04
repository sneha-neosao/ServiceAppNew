part of 'technician_bloc.dart';

/// Event for authentication related information.

sealed class TechnicianEvent extends Equatable {
  const TechnicianEvent();

  @override
  List<Object?> get props => [];
}

/// Event for Technician.

class TechnicianGetEvent extends TechnicianEvent {
  const TechnicianGetEvent();

  @override
  List<Object?> get props => [];
}
