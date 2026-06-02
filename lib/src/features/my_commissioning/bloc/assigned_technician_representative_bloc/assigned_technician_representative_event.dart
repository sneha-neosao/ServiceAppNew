import 'package:equatable/equatable.dart';

sealed class AssignedTechnicianRepresentativeEvent extends Equatable {
  const AssignedTechnicianRepresentativeEvent();

  @override
  List<Object?> get props => [];
}

class AssignedTechnicianRepresentativeGetEvent extends AssignedTechnicianRepresentativeEvent {
  final String commissioning_report_id;

  const AssignedTechnicianRepresentativeGetEvent(this.commissioning_report_id);

  @override
  List<Object?> get props => [commissioning_report_id];
}
