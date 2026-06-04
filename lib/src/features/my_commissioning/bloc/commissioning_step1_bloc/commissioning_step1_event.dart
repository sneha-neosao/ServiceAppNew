part of 'commissioning_step1_bloc.dart';

/// Event for authentication related information.

sealed class CommissioningStep1Event extends Equatable {
  const CommissioningStep1Event();

  @override
  List<Object?> get props => [];
}

/// Event for CommissioningStep1 submit.

class CommissioningStep1GetEvent extends CommissioningStep1Event {
  final String commissioning_report_id;
  final List<String> technicianIds;

  const CommissioningStep1GetEvent(
    this.commissioning_report_id,
    this.technicianIds,
  );

  @override
  List<Object?> get props => [commissioning_report_id, technicianIds];
}
