part of 'commissioning_step1_bloc.dart';

sealed class CommissioningStep1State extends Equatable {
  const CommissioningStep1State();
  @override
  List<Object?> get props => [];
}

class CommissioningStep1InitialState extends CommissioningStep1State {}

/// States like loading, success and failure representing commissioning step 1 submitting.

class CommissioningStep1LoadingState extends CommissioningStep1State {}

class CommissioningStep1lSuccessState extends CommissioningStep1State {
  final CommissioningStep1Response data;

  const CommissioningStep1lSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningStep1FailureState extends CommissioningStep1State {
  final String message;

  const CommissioningStep1FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
