import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart';

sealed class CommissioningStep5AutoFillState extends Equatable {
  const CommissioningStep5AutoFillState();

  @override
  List<Object> get props => [];
}

final class CommissioningStep5AutoFillInitialState
    extends CommissioningStep5AutoFillState {}

class CommissioningStep5AutoFillLoadingState
    extends CommissioningStep5AutoFillState {}

class CommissioningStep5AutoFillSuccessState
    extends CommissioningStep5AutoFillState {
  final CommissioningReportStep5AutoFillResponse data;

  const CommissioningStep5AutoFillSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CommissioningStep5AutoFillFailureState
    extends CommissioningStep5AutoFillState {
  final String message;

  const CommissioningStep5AutoFillFailureState(this.message);

  @override
  List<Object> get props => [message];
}
