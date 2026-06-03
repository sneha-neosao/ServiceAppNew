import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step5_model/servicecall_report_step5_response.dart';

abstract class ServiceCallReportStep5State extends Equatable {
  const ServiceCallReportStep5State();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep5InitialState extends ServiceCallReportStep5State {}

class ServiceCallReportStep5LoadingState extends ServiceCallReportStep5State {}

class ServiceCallReportStep5SuccessState extends ServiceCallReportStep5State {
  final ServiceCallStep5Response data;

  const ServiceCallReportStep5SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep5FailureState extends ServiceCallReportStep5State {
  final String message;

  const ServiceCallReportStep5FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
