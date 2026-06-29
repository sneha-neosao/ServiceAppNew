import 'package:equatable/equatable.dart';

abstract class ServiceWorkReportStep3AutofillEvent extends Equatable {
  const ServiceWorkReportStep3AutofillEvent();

  @override
  List<Object> get props => [];
}

class GetServiceWorkReportStep3AutofillEvent
    extends ServiceWorkReportStep3AutofillEvent {
  final String reportId;

  const GetServiceWorkReportStep3AutofillEvent(this.reportId);

  @override
  List<Object> get props => [reportId];
}
