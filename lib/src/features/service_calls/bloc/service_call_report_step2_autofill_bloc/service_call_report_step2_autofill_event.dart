import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep2AutoFillEvent extends Equatable {
  const ServiceCallReportStep2AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep2AutoFillGetEvent extends ServiceCallReportStep2AutoFillEvent {
  final String complaintId;

  const ServiceCallReportStep2AutoFillGetEvent(this.complaintId);

  @override
  List<Object?> get props => [complaintId];
}
