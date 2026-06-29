import 'package:equatable/equatable.dart';

abstract class ServiceWorkReportTechniciansEvent extends Equatable {
  const ServiceWorkReportTechniciansEvent();

  @override
  List<Object> get props => [];
}

class FetchServiceWorkReportTechniciansEvent
    extends ServiceWorkReportTechniciansEvent {
  final String reportId;

  const FetchServiceWorkReportTechniciansEvent(this.reportId);

  @override
  List<Object> get props => [reportId];
}
