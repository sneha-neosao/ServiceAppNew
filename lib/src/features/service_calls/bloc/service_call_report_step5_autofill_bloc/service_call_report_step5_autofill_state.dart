import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step5_model/servicecall_report_step5_response.dart';

abstract class ServiceCallReportStep5AutoFillState extends Equatable {
  const ServiceCallReportStep5AutoFillState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep5AutoFillInitialState
    extends ServiceCallReportStep5AutoFillState {}

class ServiceCallReportStep5AutoFillLoadingState
    extends ServiceCallReportStep5AutoFillState {}

class ServiceCallReportStep5AutoFillSuccessState
    extends ServiceCallReportStep5AutoFillState {
  final ServiceCallStep5Response data;

  const ServiceCallReportStep5AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep5AutoFillFailureState
    extends ServiceCallReportStep5AutoFillState {
  final String message;

  const ServiceCallReportStep5AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
