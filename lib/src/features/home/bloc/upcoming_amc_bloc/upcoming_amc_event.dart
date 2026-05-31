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

  const UpcomingAmcGetEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
