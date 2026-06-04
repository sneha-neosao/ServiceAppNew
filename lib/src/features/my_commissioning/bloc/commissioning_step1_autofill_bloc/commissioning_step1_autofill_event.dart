part of 'commissioning_step1_autofill_bloc.dart';

/// Event for authentication related information.

sealed class CommissioningStep1AutoFillEvent extends Equatable {
  const CommissioningStep1AutoFillEvent();

  @override
  List<Object?> get props => [];
}

/// Event for CommissioningStep1AutoFill.

class CommissioningStep1AutoFillGetEvent
    extends CommissioningStep1AutoFillEvent {
  final String commissioning_report_id;

  const CommissioningStep1AutoFillGetEvent(this.commissioning_report_id);

  @override
  List<Object?> get props => [commissioning_report_id];
}
