import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep1AutoFillEvent extends Equatable {
  const ServiceCallReportStep1AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep1AutoFillGetEvent
    extends ServiceCallReportStep1AutoFillEvent {
  final String complaintId;

  const ServiceCallReportStep1AutoFillGetEvent(this.complaintId);

  @override
  List<Object?> get props => [complaintId];
}
