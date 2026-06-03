import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep4Event extends Equatable {
  const ServiceCallReportStep4Event();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep4PostEvent extends ServiceCallReportStep4Event {
  final String reportId;
  final List<Map<String, dynamic>> descriptions;

  const ServiceCallReportStep4PostEvent({
    required this.reportId,
    required this.descriptions,
  });

  @override
  List<Object?> get props => [reportId, descriptions];
}
