import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecall_report_step3_model/servicecall_report_step3_response.dart';

abstract class ServiceCallReportStep3AutoFillState extends Equatable {
  const ServiceCallReportStep3AutoFillState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep3AutoFillInitialState extends ServiceCallReportStep3AutoFillState {}

class ServiceCallReportStep3AutoFillLoadingState extends ServiceCallReportStep3AutoFillState {}

class ServiceCallReportStep3AutoFillSuccessState extends ServiceCallReportStep3AutoFillState {
  final ServiceCallStep3Response data;

  const ServiceCallReportStep3AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep3AutoFillFailureState extends ServiceCallReportStep3AutoFillState {
  final String message;

  const ServiceCallReportStep3AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
