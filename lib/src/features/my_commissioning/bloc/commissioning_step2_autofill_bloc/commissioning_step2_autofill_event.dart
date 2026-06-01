part of 'commissioning_step2_autofill_bloc.dart';

/// Event for authentication related information.

sealed class CommissioningStep2AutoFillEvent extends Equatable {
  const CommissioningStep2AutoFillEvent();

  @override
  List<Object?> get props => [];
}

/// Event for CommissioningStep2AutoFill.

class CommissioningStep2AutoFillGetEvent extends CommissioningStep2AutoFillEvent {

  final String commissioning_report_id;

  const CommissioningStep2AutoFillGetEvent(this.commissioning_report_id);

  @override
  List<Object?> get props => [commissioning_report_id];
}
