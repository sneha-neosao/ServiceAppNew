import 'package:equatable/equatable.dart';
import '../../../../remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart';

sealed class CommissioningStep4Event extends Equatable {
  const CommissioningStep4Event();

  @override
  List<Object> get props => [];
}

class CommissioningStep4GetEvent extends CommissioningStep4Event {
  final String commissioning_report_id;
  final List<SavedDescription> descriptions;

  const CommissioningStep4GetEvent(
    this.commissioning_report_id,
    this.descriptions,
  );

  @override
  List<Object> get props => [commissioning_report_id, descriptions];
}
