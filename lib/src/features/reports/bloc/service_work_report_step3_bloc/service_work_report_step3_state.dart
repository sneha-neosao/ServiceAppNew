import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';

abstract class ServiceWorkReportStep3State extends Equatable {
  const ServiceWorkReportStep3State();

  @override
  List<Object> get props => [];
}

class ServiceWorkReportStep3Initial extends ServiceWorkReportStep3State {}

class ServiceWorkReportStep3Loading extends ServiceWorkReportStep3State {}

class ServiceWorkReportStep3Success extends ServiceWorkReportStep3State {
  final ServiceWorkReportStep3Response data;

  const ServiceWorkReportStep3Success(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceWorkReportStep3Failure extends ServiceWorkReportStep3State {
  final String error;

  const ServiceWorkReportStep3Failure(this.error);

  @override
  List<Object> get props => [error];
}
