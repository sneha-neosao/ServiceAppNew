import 'package:equatable/equatable.dart';

sealed class CommissioningStep3AutoFillState extends Equatable {
  const CommissioningStep3AutoFillState();

  @override
  List<Object?> get props => [];
}

class CommissioningStep3AutoFillInitialState
    extends CommissioningStep3AutoFillState {}

class CommissioningStep3AutoFillLoadingState
    extends CommissioningStep3AutoFillState {}

class CommissioningStep3AutoFillSuccessState
    extends CommissioningStep3AutoFillState {
  final dynamic data;

  const CommissioningStep3AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningStep3AutoFillFailureState
    extends CommissioningStep3AutoFillState {
  final String message;

  const CommissioningStep3AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
