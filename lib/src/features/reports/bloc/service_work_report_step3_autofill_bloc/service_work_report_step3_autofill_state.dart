import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';

abstract class ServiceWorkReportStep3AutofillState extends Equatable {
  const ServiceWorkReportStep3AutofillState();

  @override
  List<Object> get props => [];
}

class ServiceWorkReportStep3AutofillInitial
    extends ServiceWorkReportStep3AutofillState {}

class ServiceWorkReportStep3AutofillLoading
    extends ServiceWorkReportStep3AutofillState {}

class ServiceWorkReportStep3AutofillSuccess
    extends ServiceWorkReportStep3AutofillState {
  final ServiceWorkReportStep3Response data;

  const ServiceWorkReportStep3AutofillSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceWorkReportStep3AutofillFailure
    extends ServiceWorkReportStep3AutofillState {
  final String error;

  const ServiceWorkReportStep3AutofillFailure(this.error);

  @override
  List<Object> get props => [error];
}
