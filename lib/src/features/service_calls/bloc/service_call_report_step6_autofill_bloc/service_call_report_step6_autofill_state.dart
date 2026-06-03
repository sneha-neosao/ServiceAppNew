import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep6AutoFillState extends Equatable {
  const ServiceCallReportStep6AutoFillState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep6AutoFillInitialState extends ServiceCallReportStep6AutoFillState {}

class ServiceCallReportStep6AutoFillLoadingState extends ServiceCallReportStep6AutoFillState {}

class ServiceCallReportStep6AutoFillSuccessState extends ServiceCallReportStep6AutoFillState {
  final dynamic data;
  const ServiceCallReportStep6AutoFillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallReportStep6AutoFillFailureState extends ServiceCallReportStep6AutoFillState {
  final String message;
  const ServiceCallReportStep6AutoFillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
