import 'package:equatable/equatable.dart';

sealed class CommissioningStep3AutoFillEvent extends Equatable {
  const CommissioningStep3AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningStep3AutoFillGetEvent extends CommissioningStep3AutoFillEvent {
  final String commissioning_report_id;

  const CommissioningStep3AutoFillGetEvent(this.commissioning_report_id);

  @override
  List<Object?> get props => [commissioning_report_id];
}
