import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step4_model/service_work_report_step4_response.dart';

abstract class ServiceWorkReportStep4AutofillState extends Equatable {
  const ServiceWorkReportStep4AutofillState();

  @override
  List<Object?> get props => [];
}

class ServiceWorkReportStep4AutofillInitial extends ServiceWorkReportStep4AutofillState {}

class ServiceWorkReportStep4AutofillLoading extends ServiceWorkReportStep4AutofillState {}

class ServiceWorkReportStep4AutofillSuccess extends ServiceWorkReportStep4AutofillState {
  final ServiceWorkReportStep4Response data;

  const ServiceWorkReportStep4AutofillSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceWorkReportStep4AutofillFailure extends ServiceWorkReportStep4AutofillState {
  final String error;

  const ServiceWorkReportStep4AutofillFailure(this.error);

  @override
  List<Object?> get props => [error];
}
