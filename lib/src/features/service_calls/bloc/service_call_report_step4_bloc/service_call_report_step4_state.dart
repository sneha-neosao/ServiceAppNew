import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step4_model/servicecall_report_step4_response.dart';

abstract class ServiceCallReportStep4State extends Equatable {
  const ServiceCallReportStep4State();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep4InitialState extends ServiceCallReportStep4State {}

class ServiceCallReportStep4LoadingState extends ServiceCallReportStep4State {}

class ServiceCallReportStep4SuccessState extends ServiceCallReportStep4State {
  final ServiceCallStep4Response data;

  const ServiceCallReportStep4SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep4FailureState extends ServiceCallReportStep4State {
  final String message;

  const ServiceCallReportStep4FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
