import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep5Event extends Equatable {
  const ServiceCallReportStep5Event();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep5PostEvent extends ServiceCallReportStep5Event {
  final String reportId;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<Map<String, dynamic>> checklistItems;

  const ServiceCallReportStep5PostEvent({
    required this.reportId,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.checklistItems,
  });

  @override
  List<Object?> get props => [
        reportId,
        isMechanicalChecklistNa,
        isPipelineChecklistNa,
        isElectricalChecklistNa,
        checklistItems,
      ];
}
