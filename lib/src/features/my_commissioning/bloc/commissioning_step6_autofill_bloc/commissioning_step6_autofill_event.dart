import 'package:equatable/equatable.dart';

sealed class CommissioningStep6AutoFillEvent extends Equatable {
  const CommissioningStep6AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningStep6AutoFillGetEvent
    extends CommissioningStep6AutoFillEvent {
  final String commissioning_report_id;

  const CommissioningStep6AutoFillGetEvent(this.commissioning_report_id);

  @override
  List<Object?> get props => [commissioning_report_id];
}
