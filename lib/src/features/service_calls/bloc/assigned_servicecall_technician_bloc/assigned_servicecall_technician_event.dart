import 'package:equatable/equatable.dart';

abstract class AssignedServicecallTechnicianEvent extends Equatable {
  const AssignedServicecallTechnicianEvent();

  @override
  List<Object?> get props => [];
}

class AssignedServicecallTechnicianGetEvent
    extends AssignedServicecallTechnicianEvent {
  final String reportId;

  const AssignedServicecallTechnicianGetEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
