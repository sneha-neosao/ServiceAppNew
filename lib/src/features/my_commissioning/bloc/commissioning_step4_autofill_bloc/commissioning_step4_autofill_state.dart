import 'package:equatable/equatable.dart';
import '../../../../remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';

sealed class CommissioningStep4AutoFillState extends Equatable {
  const CommissioningStep4AutoFillState();

  @override
  List<Object> get props => [];
}

final class CommissioningStep4AutoFillInitialState extends CommissioningStep4AutoFillState {}

class CommissioningStep4AutoFillLoadingState extends CommissioningStep4AutoFillState {}

class CommissioningStep4AutoFillSuccessState extends CommissioningStep4AutoFillState {
  final CommissioningReportStep4AutoFillResponse data;

  const CommissioningStep4AutoFillSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CommissioningStep4AutoFillFailureState extends CommissioningStep4AutoFillState {
  final String message;

  const CommissioningStep4AutoFillFailureState(this.message);

  @override
  List<Object> get props => [message];
}
