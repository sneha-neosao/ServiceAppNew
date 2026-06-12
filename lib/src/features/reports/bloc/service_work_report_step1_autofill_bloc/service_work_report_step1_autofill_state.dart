import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step1_model/service_work_report_step1_response.dart';

abstract class ServiceWorkReportStep1AutofillState extends Equatable {
  const ServiceWorkReportStep1AutofillState();

  @override
  List<Object> get props => [];
}

class ServiceWorkReportStep1AutofillInitial
    extends ServiceWorkReportStep1AutofillState {}

class ServiceWorkReportStep1AutofillLoading
    extends ServiceWorkReportStep1AutofillState {}

class ServiceWorkReportStep1AutofillSuccess
    extends ServiceWorkReportStep1AutofillState {
  final ServiceWorkReportStep1Response data;

  const ServiceWorkReportStep1AutofillSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceWorkReportStep1AutofillFailure
    extends ServiceWorkReportStep1AutofillState {
  final String message;

  const ServiceWorkReportStep1AutofillFailure(this.message);

  @override
  List<Object> get props => [message];
}
