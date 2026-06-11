import 'package:equatable/equatable.dart';

abstract class AmcAssignedTechniciansEvent extends Equatable {
  const AmcAssignedTechniciansEvent();

  @override
  List<Object?> get props => [];
}

class GetAmcAssignedTechniciansEvent extends AmcAssignedTechniciansEvent {
  final String reportId;

  const GetAmcAssignedTechniciansEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
