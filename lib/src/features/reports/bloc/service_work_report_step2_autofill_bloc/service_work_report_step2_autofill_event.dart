import 'package:equatable/equatable.dart';

abstract class ServiceWorkReportStep2AutofillEvent extends Equatable {
  const ServiceWorkReportStep2AutofillEvent();

  @override
  List<Object> get props => [];
}

class GetServiceWorkReportStep2AutofillEvent
    extends ServiceWorkReportStep2AutofillEvent {
  final String reportId;

  const GetServiceWorkReportStep2AutofillEvent(this.reportId);

  @override
  List<Object> get props => [reportId];
}
