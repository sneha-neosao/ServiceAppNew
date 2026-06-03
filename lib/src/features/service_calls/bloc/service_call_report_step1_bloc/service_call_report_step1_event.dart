import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';

abstract class ServiceCallReportStep1Event extends Equatable {
  const ServiceCallReportStep1Event();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep1PostEvent extends ServiceCallReportStep1Event {
  final ServiceCallReportStep1Params params;

  const ServiceCallReportStep1PostEvent(this.params);

  @override
  List<Object?> get props => [params];
}
