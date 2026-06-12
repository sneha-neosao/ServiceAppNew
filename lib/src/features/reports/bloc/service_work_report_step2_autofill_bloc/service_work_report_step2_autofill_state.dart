import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step2_model/service_work_report_step2_response.dart';

abstract class ServiceWorkReportStep2AutofillState extends Equatable {
  const ServiceWorkReportStep2AutofillState();

  @override
  List<Object> get props => [];
}

class ServiceWorkReportStep2AutofillInitial
    extends ServiceWorkReportStep2AutofillState {}

class ServiceWorkReportStep2AutofillLoading
    extends ServiceWorkReportStep2AutofillState {}

class ServiceWorkReportStep2AutofillSuccess
    extends ServiceWorkReportStep2AutofillState {
  final ServiceWorkReportStep2Response data;

  const ServiceWorkReportStep2AutofillSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceWorkReportStep2AutofillFailure
    extends ServiceWorkReportStep2AutofillState {
  final String message;

  const ServiceWorkReportStep2AutofillFailure(this.message);

  @override
  List<Object> get props => [message];
}
