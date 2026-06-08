part of 'amc_visits_list_bloc.dart';

sealed class AmcVisitsListState extends Equatable {
  const AmcVisitsListState();

  @override
  List<Object?> get props => [];
}

class AmcVisitsListInitialState extends AmcVisitsListState {}

class AmcVisitsListLoadingState extends AmcVisitsListState {}

class AmcVisitsListSuccessState extends AmcVisitsListState {
  final AmcVisitsListResponse data;

  const AmcVisitsListSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcVisitsListFailureState extends AmcVisitsListState {
  final String error;

  const AmcVisitsListFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
