import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';

sealed class CommissioningStep6State extends Equatable {
  const CommissioningStep6State();

  @override
  List<Object> get props => [];
}

final class CommissioningStep6InitialState extends CommissioningStep6State {}

class CommissioningStep6LoadingState extends CommissioningStep6State {}

class CommissioningStep6SuccessState extends CommissioningStep6State {
  final CommissioningReportStep6AutoFillResponse data;

  const CommissioningStep6SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CommissioningStep6FailureState extends CommissioningStep6State {
  final String message;

  const CommissioningStep6FailureState(this.message);

  @override
  List<Object> get props => [message];
}
