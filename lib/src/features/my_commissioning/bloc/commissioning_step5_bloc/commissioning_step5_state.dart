import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart';

sealed class CommissioningStep5State extends Equatable {
  const CommissioningStep5State();

  @override
  List<Object> get props => [];
}

final class CommissioningStep5InitialState extends CommissioningStep5State {}

class CommissioningStep5LoadingState extends CommissioningStep5State {}

class CommissioningStep5SuccessState extends CommissioningStep5State {
  final CommissioningReportStep5AutoFillResponse data;

  const CommissioningStep5SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CommissioningStep5FailureState extends CommissioningStep5State {
  final String message;

  const CommissioningStep5FailureState(this.message);

  @override
  List<Object> get props => [message];
}
