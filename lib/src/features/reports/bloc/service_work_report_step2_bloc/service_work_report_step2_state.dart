import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step2_model/service_work_report_step2_response.dart';

abstract class ServiceWorkReportStep2State extends Equatable {
  const ServiceWorkReportStep2State();

  @override
  List<Object> get props => [];
}

class ServiceWorkReportStep2Initial extends ServiceWorkReportStep2State {}

class ServiceWorkReportStep2Loading extends ServiceWorkReportStep2State {}

class ServiceWorkReportStep2Success extends ServiceWorkReportStep2State {
  final ServiceWorkReportStep2Response data;

  const ServiceWorkReportStep2Success(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceWorkReportStep2Failure extends ServiceWorkReportStep2State {
  final String error;

  const ServiceWorkReportStep2Failure(this.error);

  @override
  List<Object> get props => [error];
}
