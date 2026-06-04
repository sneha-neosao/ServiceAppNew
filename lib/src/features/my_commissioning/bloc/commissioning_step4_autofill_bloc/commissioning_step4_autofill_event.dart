import 'package:equatable/equatable.dart';

sealed class CommissioningStep4AutoFillEvent extends Equatable {
  const CommissioningStep4AutoFillEvent();

  @override
  List<Object> get props => [];
}

class CommissioningStep4AutoFillGetEvent
    extends CommissioningStep4AutoFillEvent {
  final String commissioning_report_id;

  const CommissioningStep4AutoFillGetEvent(this.commissioning_report_id);

  @override
  List<Object> get props => [commissioning_report_id];
}
