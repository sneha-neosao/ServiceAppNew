import 'package:equatable/equatable.dart';

enum ServiceCallPdfAction { view, download }

abstract class ServiceCallReportPdfEvent extends Equatable {
  const ServiceCallReportPdfEvent();

  @override
  List<Object> get props => [];
}

class FetchServiceCallReportPdfEvent extends ServiceCallReportPdfEvent {
  final String reportId;
  final ServiceCallPdfAction action;

  const FetchServiceCallReportPdfEvent({
    required this.reportId,
    required this.action,
  });

  @override
  List<Object> get props => [reportId, action];
}
