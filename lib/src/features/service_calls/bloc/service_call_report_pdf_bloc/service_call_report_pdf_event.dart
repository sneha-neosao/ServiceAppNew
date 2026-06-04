import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_pdf_bloc/commissioning_report_pdf_event.dart';

abstract class ServiceCallReportPdfEvent extends Equatable {
  const ServiceCallReportPdfEvent();

  @override
  List<Object> get props => [];
}

class FetchServiceCallReportPdfEvent extends ServiceCallReportPdfEvent {
  final String reportId;
  final PdfAction action;

  const FetchServiceCallReportPdfEvent({
    required this.reportId,
    required this.action,
  });

  @override
  List<Object> get props => [reportId, action];
}
