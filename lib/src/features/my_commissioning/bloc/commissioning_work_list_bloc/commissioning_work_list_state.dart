part of 'commissioning_work_list_bloc.dart';

sealed class CommissioningWorkListState extends Equatable {
  const CommissioningWorkListState();
  @override
  List<Object?> get props => [];
}

class CommissioningWorkListInitialState extends CommissioningWorkListState {}

/// States like loading, success and failure representing commissioning work list fetching.

class CommissioningWorkListLoadingState extends CommissioningWorkListState {}

class CommissioningWorkListSuccessState extends CommissioningWorkListState {
  final CommissioningWorkListResponse data;

  const CommissioningWorkListSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningWorkListFailureState extends CommissioningWorkListState {
  final String message;

  const CommissioningWorkListFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
