import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step1_model/servicecall_report_step1_response.dart';

abstract class ServiceCallReportStep1State extends Equatable {
  const ServiceCallReportStep1State();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep1InitialState extends ServiceCallReportStep1State {}

class ServiceCallReportStep1LoadingState extends ServiceCallReportStep1State {}

class ServiceCallReportStep1SuccessState extends ServiceCallReportStep1State {
  final ServiceCallStep1Response data;

  const ServiceCallReportStep1SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep1FailureState extends ServiceCallReportStep1State {
  final String message;

  const ServiceCallReportStep1FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
