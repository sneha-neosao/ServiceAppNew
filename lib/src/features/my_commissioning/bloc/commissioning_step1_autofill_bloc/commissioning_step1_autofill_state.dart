part of 'commissioning_step1_autofill_bloc.dart';

sealed class CommissioningStep1AutoFillState extends Equatable {
  const CommissioningStep1AutoFillState();
  @override
  List<Object?> get props => [];
}

class CommissioningStep1AutoFillInitialState extends CommissioningStep1AutoFillState {}

/// States like loading, success and failure representing commissioning step 1 auto fill data fetching.

class CommissioningStep1AutoFillLoadingState extends CommissioningStep1AutoFillState {}

class CommissioningStep1AutoFillSuccessState extends CommissioningStep1AutoFillState {
  final CommissioningReportStep1AutoFillResponse data;

  const CommissioningStep1AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningStep1AutoFillFailureState extends CommissioningStep1AutoFillState {
  final String message;

  const CommissioningStep1AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}