part of 'amc_report_pdf_bloc.dart';

abstract class AmcReportPdfState {}

class AmcReportPdfInitial extends AmcReportPdfState {}

class AmcReportPdfLoading extends AmcReportPdfState {}

class AmcReportPdfSuccess extends AmcReportPdfState {
  final String pdfUrl;
  final String message;

  AmcReportPdfSuccess({required this.pdfUrl, required this.message});
}

class AmcReportPdfFailure extends AmcReportPdfState {
  final String error;

  AmcReportPdfFailure({required this.error});
}
