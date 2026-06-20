import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_complaint_pdf_model/servicecall_complaint_pdf_response.dart';
import 'service_call_complaint_pdf_event.dart';

abstract class ServiceCallComplaintPdfState extends Equatable {
  const ServiceCallComplaintPdfState();

  @override
  List<Object> get props => [];
}

class ServiceCallComplaintPdfInitial extends ServiceCallComplaintPdfState {}

class ServiceCallComplaintPdfLoading extends ServiceCallComplaintPdfState {}

class ServiceCallComplaintPdfLoaded extends ServiceCallComplaintPdfState {
  final ServiceCallComplaintPdfResponse response;
  final ServiceCallComplaintPdfAction action;

  const ServiceCallComplaintPdfLoaded(this.response, this.action);

  @override
  List<Object> get props => [response, action];
}

class ServiceCallComplaintPdfError extends ServiceCallComplaintPdfState {
  final String message;

  const ServiceCallComplaintPdfError(this.message);

  @override
  List<Object> get props => [message];
}
