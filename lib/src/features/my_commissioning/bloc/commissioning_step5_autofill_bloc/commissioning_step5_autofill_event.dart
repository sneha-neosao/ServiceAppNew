import 'package:equatable/equatable.dart';

sealed class CommissioningStep5AutoFillEvent extends Equatable {
  const CommissioningStep5AutoFillEvent();

  @override
  List<Object> get props => [];
}

class CommissioningStep5AutoFillGetEvent
    extends CommissioningStep5AutoFillEvent {
  final String commissioning_report_id;

  const CommissioningStep5AutoFillGetEvent(this.commissioning_report_id);

  @override
  List<Object> get props => [commissioning_report_id];
}
