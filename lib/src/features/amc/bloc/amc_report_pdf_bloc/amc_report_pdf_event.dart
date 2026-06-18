part of 'amc_report_pdf_bloc.dart';

abstract class AmcReportPdfEvent {}

class FetchAmcReportPdfEvent extends AmcReportPdfEvent {
  final String reportId;

  FetchAmcReportPdfEvent({required this.reportId});
}
