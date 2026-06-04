part of 'commissioning_work_create_bloc.dart';

sealed class CommissioningWorkCreateState extends Equatable {
  const CommissioningWorkCreateState();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkCreateInitialState
    extends CommissioningWorkCreateState {}

class CommissioningWorkCreateLoadingState
    extends CommissioningWorkCreateState {}

class CommissioningWorkCreateSuccessState extends CommissioningWorkCreateState {
  final CommissioningWorkCreateResponse data;

  const CommissioningWorkCreateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningWorkCreateFailureState extends CommissioningWorkCreateState {
  final String message;

  const CommissioningWorkCreateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
