part of 'amc_visits_list_bloc.dart';

sealed class AmcVisitsListEvent extends Equatable {
  const AmcVisitsListEvent();

  @override
  List<Object?> get props => [];
}

class AmcVisitsListGetEvent extends AmcVisitsListEvent {
  const AmcVisitsListGetEvent();
}
