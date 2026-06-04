part of 'commissioning_step2_bloc.dart';

sealed class CommissioningStep2State extends Equatable {
  const CommissioningStep2State();
  @override
  List<Object?> get props => [];
}

class CommissioningStep2InitialState extends CommissioningStep2State {}

/// States like loading, success and failure representing commissioning step 1 submitting.

class CommissioningStep2LoadingState extends CommissioningStep2State {}

class CommissioningStep2SuccessState extends CommissioningStep2State {
  final CommissioningStep2Response data;

  const CommissioningStep2SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningStep2FailureState extends CommissioningStep2State {
  final String message;

  const CommissioningStep2FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
