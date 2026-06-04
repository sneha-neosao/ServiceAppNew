import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep5AutoFillEvent extends Equatable {
  const ServiceCallReportStep5AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep5AutoFillGetEvent
    extends ServiceCallReportStep5AutoFillEvent {
  final String reportId;

  const ServiceCallReportStep5AutoFillGetEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
