import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step1_model/service_work_report_step1_response.dart';

abstract class ServiceWorkReportStep1State extends Equatable {
  const ServiceWorkReportStep1State();

  @override
  List<Object?> get props => [];
}

class ServiceWorkReportStep1Initial extends ServiceWorkReportStep1State {}

class ServiceWorkReportStep1Loading extends ServiceWorkReportStep1State {}

class ServiceWorkReportStep1Success extends ServiceWorkReportStep1State {
  final ServiceWorkReportStep1Response data;

  const ServiceWorkReportStep1Success(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceWorkReportStep1Failure extends ServiceWorkReportStep1State {
  final String message;

  const ServiceWorkReportStep1Failure(this.message);

  @override
  List<Object?> get props => [message];
}
