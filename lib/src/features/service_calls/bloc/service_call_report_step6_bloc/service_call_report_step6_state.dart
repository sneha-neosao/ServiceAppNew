import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step6_model/servicecall_report_step6_response.dart';

abstract class ServiceCallReportStep6State extends Equatable {
  const ServiceCallReportStep6State();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep6InitialState extends ServiceCallReportStep6State {}

class ServiceCallReportStep6LoadingState extends ServiceCallReportStep6State {}

class ServiceCallReportStep6SuccessState extends ServiceCallReportStep6State {
  final ServiceCallStep6Response data;

  const ServiceCallReportStep6SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep6FailureState extends ServiceCallReportStep6State {
  final String message;

  const ServiceCallReportStep6FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
