import 'package:equatable/equatable.dart';

abstract class ServiceWorkReportStep1AutofillEvent extends Equatable {
  const ServiceWorkReportStep1AutofillEvent();

  @override
  List<Object> get props => [];
}

class GetServiceWorkReportStep1AutofillEvent
    extends ServiceWorkReportStep1AutofillEvent {
  final String complaintId;

  const GetServiceWorkReportStep1AutofillEvent(this.complaintId);

  @override
  List<Object> get props => [complaintId];
}
