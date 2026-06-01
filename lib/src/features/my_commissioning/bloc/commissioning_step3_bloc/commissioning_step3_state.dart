import 'package:equatable/equatable.dart';

sealed class CommissioningStep3State extends Equatable {
  const CommissioningStep3State();

  @override
  List<Object?> get props => [];
}

class CommissioningStep3InitialState extends CommissioningStep3State {}

class CommissioningStep3LoadingState extends CommissioningStep3State {}

class CommissioningStep3SuccessState extends CommissioningStep3State {
  final dynamic data;

  const CommissioningStep3SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningStep3FailureState extends CommissioningStep3State {
  final String message;

  const CommissioningStep3FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
