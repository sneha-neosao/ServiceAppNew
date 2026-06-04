import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep4AutoFillEvent extends Equatable {
  const ServiceCallReportStep4AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep4AutoFillGetEvent
    extends ServiceCallReportStep4AutoFillEvent {
  final String complaintId;

  const ServiceCallReportStep4AutoFillGetEvent(this.complaintId);

  @override
  List<Object?> get props => [complaintId];
}
