import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_assigned_technicians_response.dart';

abstract class AmcAssignedTechniciansState extends Equatable {
  const AmcAssignedTechniciansState();

  @override
  List<Object?> get props => [];
}

class AmcAssignedTechniciansInitialState extends AmcAssignedTechniciansState {}

class AmcAssignedTechniciansLoadingState extends AmcAssignedTechniciansState {}

class AmcAssignedTechniciansSuccessState extends AmcAssignedTechniciansState {
  final AmcAssignedTechniciansResponse data;

  const AmcAssignedTechniciansSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcAssignedTechniciansFailureState extends AmcAssignedTechniciansState {
  final String message;

  const AmcAssignedTechniciansFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
