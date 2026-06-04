import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step4_model/servicecall_report_step4_response.dart';

abstract class ServiceCallReportStep4AutoFillState extends Equatable {
  const ServiceCallReportStep4AutoFillState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep4AutoFillInitialState
    extends ServiceCallReportStep4AutoFillState {}

class ServiceCallReportStep4AutoFillLoadingState
    extends ServiceCallReportStep4AutoFillState {}

class ServiceCallReportStep4AutoFillSuccessState
    extends ServiceCallReportStep4AutoFillState {
  final ServiceCallStep4Response data;

  const ServiceCallReportStep4AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep4AutoFillFailureState
    extends ServiceCallReportStep4AutoFillState {
  final String message;

  const ServiceCallReportStep4AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
