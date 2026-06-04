import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step5_usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart';

sealed class CommissioningStep5Event extends Equatable {
  const CommissioningStep5Event();

  @override
  List<Object> get props => [];
}

class CommissioningStep5GetEvent extends CommissioningStep5Event {
  final String commissioning_report_id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<SavedChecklist> checklistItems;

  const CommissioningStep5GetEvent(
    this.commissioning_report_id,
    this.isMechanicalChecklistNa,
    this.isPipelineChecklistNa,
    this.isElectricalChecklistNa,
    this.checklistItems,
  );

  @override
  List<Object> get props => [
    commissioning_report_id,
    isMechanicalChecklistNa,
    isPipelineChecklistNa,
    isElectricalChecklistNa,
    checklistItems,
  ];
}
