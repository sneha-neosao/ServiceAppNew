import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step2_model/servicecall_report_step2_response.dart';

abstract class ServiceCallReportStep2State extends Equatable {
  const ServiceCallReportStep2State();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep2InitialState extends ServiceCallReportStep2State {}

class ServiceCallReportStep2LoadingState extends ServiceCallReportStep2State {}

class ServiceCallReportStep2SuccessState extends ServiceCallReportStep2State {
  final ServiceCallStep2Response data;

  const ServiceCallReportStep2SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep2FailureState extends ServiceCallReportStep2State {
  final String message;

  const ServiceCallReportStep2FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
