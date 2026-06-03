import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step3_model/servicecall_report_step3_response.dart';

abstract class ServiceCallReportStep3State extends Equatable {
  const ServiceCallReportStep3State();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep3InitialState extends ServiceCallReportStep3State {}

class ServiceCallReportStep3LoadingState extends ServiceCallReportStep3State {}

class ServiceCallReportStep3SuccessState extends ServiceCallReportStep3State {
  final ServiceCallStep3Response data;

  const ServiceCallReportStep3SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep3FailureState extends ServiceCallReportStep3State {
  final String message;

  const ServiceCallReportStep3FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
