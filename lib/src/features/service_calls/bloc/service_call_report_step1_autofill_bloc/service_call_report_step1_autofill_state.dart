import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step1_model/servicecall_report_step1_response.dart';

abstract class ServiceCallReportStep1AutoFillState extends Equatable {
  const ServiceCallReportStep1AutoFillState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep1AutoFillInitialState
    extends ServiceCallReportStep1AutoFillState {}

class ServiceCallReportStep1AutoFillLoadingState
    extends ServiceCallReportStep1AutoFillState {}

class ServiceCallReportStep1AutoFillSuccessState
    extends ServiceCallReportStep1AutoFillState {
  final ServiceCallStep1Response data;

  const ServiceCallReportStep1AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep1AutoFillFailureState
    extends ServiceCallReportStep1AutoFillState {
  final String message;

  const ServiceCallReportStep1AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
