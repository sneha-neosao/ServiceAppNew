import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';

sealed class CommissioningStep6AutoFillState extends Equatable {
  const CommissioningStep6AutoFillState();

  @override
  List<Object> get props => [];
}

final class CommissioningStep6AutoFillInitialState extends CommissioningStep6AutoFillState {}

class CommissioningStep6AutoFillLoadingState extends CommissioningStep6AutoFillState {}

class CommissioningStep6AutoFillSuccessState extends CommissioningStep6AutoFillState {
  final CommissioningReportStep6AutoFillResponse data;

  const CommissioningStep6AutoFillSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CommissioningStep6AutoFillFailureState extends CommissioningStep6AutoFillState {
  final String message;

  const CommissioningStep6AutoFillFailureState(this.message);

  @override
  List<Object> get props => [message];
}
