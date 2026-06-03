import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep6AutoFillEvent extends Equatable {
  const ServiceCallReportStep6AutoFillEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep6AutoFillGetEvent extends ServiceCallReportStep6AutoFillEvent {
  final String reportId;

  const ServiceCallReportStep6AutoFillGetEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
