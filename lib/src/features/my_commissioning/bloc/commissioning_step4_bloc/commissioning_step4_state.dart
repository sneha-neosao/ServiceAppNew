import 'package:equatable/equatable.dart';
import '../../../../remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';

sealed class CommissioningStep4State extends Equatable {
  const CommissioningStep4State();

  @override
  List<Object> get props => [];
}

final class CommissioningStep4InitialState extends CommissioningStep4State {}

class CommissioningStep4LoadingState extends CommissioningStep4State {}

class CommissioningStep4SuccessState extends CommissioningStep4State {
  final CommissioningReportStep4AutoFillResponse data;

  const CommissioningStep4SuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CommissioningStep4FailureState extends CommissioningStep4State {
  final String message;

  const CommissioningStep4FailureState(this.message);

  @override
  List<Object> get props => [message];
}
