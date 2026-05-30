part of 'commissioning_work_list_bloc.dart';

/// Event for authentication related information.

sealed class CommissioningWorkListEvent extends Equatable {
  const CommissioningWorkListEvent();

  @override
  List<Object?> get props => [];
}

/// Event for Customer.

class CommissioningWorkListGetEvent extends CommissioningWorkListEvent {

  const CommissioningWorkListGetEvent();

  @override
  List<Object?> get props => [];
}
