import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_pdf_response.dart';
import 'service_call_report_pdf_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_pdf_bloc/commissioning_report_pdf_event.dart';

abstract class ServiceCallReportPdfState extends Equatable {
  const ServiceCallReportPdfState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportPdfInitial extends ServiceCallReportPdfState {}

class ServiceCallReportPdfLoading extends ServiceCallReportPdfState {}

class ServiceCallReportPdfLoaded extends ServiceCallReportPdfState {
  final CommissioningReportPdfResponse response;
  final PdfAction action;

  const ServiceCallReportPdfLoaded(this.response, this.action);

  @override
  List<Object?> get props => [response, action];
}

class ServiceCallReportPdfError extends ServiceCallReportPdfState {
  final String message;

  const ServiceCallReportPdfError(this.message);

  @override
  List<Object?> get props => [message];
}
