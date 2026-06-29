import 'package:equatable/equatable.dart';

abstract class ServiceWorkReportStep4AutofillEvent extends Equatable {
  const ServiceWorkReportStep4AutofillEvent();

  @override
  List<Object> get props => [];
}

class GetServiceWorkReportStep4AutofillEvent
    extends ServiceWorkReportStep4AutofillEvent {
  final String reportId;

  const GetServiceWorkReportStep4AutofillEvent(this.reportId);

  @override
  List<Object> get props => [reportId];
}
