import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/assigned_technician_representative_model/assigned_technician_representative_response.dart';

abstract class ServiceWorkReportTechniciansState extends Equatable {
  const ServiceWorkReportTechniciansState();

  @override
  List<Object?> get props => [];
}

class ServiceWorkReportTechniciansInitial
    extends ServiceWorkReportTechniciansState {}

class ServiceWorkReportTechniciansLoading
    extends ServiceWorkReportTechniciansState {}

class ServiceWorkReportTechniciansLoaded
    extends ServiceWorkReportTechniciansState {
  final AssignedTechnicianResponse response;

  const ServiceWorkReportTechniciansLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class ServiceWorkReportTechniciansError
    extends ServiceWorkReportTechniciansState {
  final String message;

  const ServiceWorkReportTechniciansError(this.message);

  @override
  List<Object?> get props => [message];
}
