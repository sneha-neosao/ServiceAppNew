import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_pdf_response.dart';
import 'commissioning_report_pdf_event.dart';

abstract class CommissioningReportPdfState extends Equatable {
  const CommissioningReportPdfState();

  @override
  List<Object?> get props => [];
}

class CommissioningReportPdfInitial extends CommissioningReportPdfState {}

class CommissioningReportPdfLoading extends CommissioningReportPdfState {}

class CommissioningReportPdfLoaded extends CommissioningReportPdfState {
  final CommissioningReportPdfResponse response;
  final PdfAction action;

  const CommissioningReportPdfLoaded(this.response, this.action);

  @override
  List<Object?> get props => [response, action];
}

class CommissioningReportPdfError extends CommissioningReportPdfState {
  final String message;

  const CommissioningReportPdfError(this.message);

  @override
  List<Object?> get props => [message];
}
