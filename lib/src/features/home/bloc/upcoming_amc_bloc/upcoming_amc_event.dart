part of 'upcoming_amc_bloc.dart';

/// Event for authentication related information.

sealed class UpcomingAmcEvent extends Equatable {
  const UpcomingAmcEvent();

  @override
  List<Object?> get props => [];
}

/// Event for Upcoming Amc.

class UpcomingAmcGetEvent extends UpcomingAmcEvent {
  final String filter;
  final String? pending;

  const UpcomingAmcGetEvent(this.filter, {this.pending});

  @override
  List<Object?> get props => [filter, pending];
}
