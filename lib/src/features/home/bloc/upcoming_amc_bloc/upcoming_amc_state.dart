part of 'upcoming_amc_bloc.dart';

sealed class UpcomingAmcState extends Equatable {
  const UpcomingAmcState();
  @override
  List<Object?> get props => [];
}

class UpcomingAmcinitialState extends UpcomingAmcState {}

/// States like loading, success and failure representing Upcoming AMC fetching.

class UpcomingAmcLoadingState extends UpcomingAmcState {}

class UpcomingAmcSuccessState extends UpcomingAmcState {
  final UpcomingAmcVisitsResponse data;

  const UpcomingAmcSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UpcomingAmcFailureState extends UpcomingAmcState {
  final String message;

  const UpcomingAmcFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
