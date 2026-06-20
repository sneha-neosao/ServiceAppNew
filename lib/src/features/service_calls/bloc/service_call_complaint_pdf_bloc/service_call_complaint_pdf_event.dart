import 'package:equatable/equatable.dart';

enum ServiceCallComplaintPdfAction { view, download }

abstract class ServiceCallComplaintPdfEvent extends Equatable {
  const ServiceCallComplaintPdfEvent();

  @override
  List<Object> get props => [];
}

class FetchServiceCallComplaintPdfEvent extends ServiceCallComplaintPdfEvent {
  final String complaintId;
  final ServiceCallComplaintPdfAction action;

  const FetchServiceCallComplaintPdfEvent({
    required this.complaintId,
    required this.action,
  });

  @override
  List<Object> get props => [complaintId, action];
}
