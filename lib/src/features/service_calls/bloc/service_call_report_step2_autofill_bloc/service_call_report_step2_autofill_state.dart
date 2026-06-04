import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step2_model/servicecall_report_step2_response.dart';

abstract class ServiceCallReportStep2AutoFillState extends Equatable {
  const ServiceCallReportStep2AutoFillState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep2AutoFillInitialState
    extends ServiceCallReportStep2AutoFillState {}

class ServiceCallReportStep2AutoFillLoadingState
    extends ServiceCallReportStep2AutoFillState {}

class ServiceCallReportStep2AutoFillSuccessState
    extends ServiceCallReportStep2AutoFillState {
  final ServiceCallStep2Response data;

  const ServiceCallReportStep2AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep2AutoFillFailureState
    extends ServiceCallReportStep2AutoFillState {
  final String message;

  const ServiceCallReportStep2AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
