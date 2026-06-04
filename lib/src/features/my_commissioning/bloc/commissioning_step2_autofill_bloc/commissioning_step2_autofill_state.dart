part of 'commissioning_step2_autofill_bloc.dart';

sealed class CommissioningStep2AutoFillState extends Equatable {
  const CommissioningStep2AutoFillState();
  @override
  List<Object?> get props => [];
}

class CommissioningStep2AutoFillInitialState
    extends CommissioningStep2AutoFillState {}

/// States like loading, success and failure representing commissioning step 2 auto fill data fetching.

class CommissioningStep2AutoFillLoadingState
    extends CommissioningStep2AutoFillState {}

class CommissioningStep2AutoFillSuccessState
    extends CommissioningStep2AutoFillState {
  final CommissioningReportStep2AutoFillResponse data;

  const CommissioningStep2AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningStep2AutoFillFailureState
    extends CommissioningStep2AutoFillState {
  final String message;

  const CommissioningStep2AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
