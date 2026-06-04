import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep3AutoFillEvent extends Equatable {
  const ServiceCallReportStep3AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep3AutoFillGetEvent
    extends ServiceCallReportStep3AutoFillEvent {
  final String complaintId;

  const ServiceCallReportStep3AutoFillGetEvent(this.complaintId);

  @override
  List<Object?> get props => [complaintId];
}
