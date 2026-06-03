import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';

abstract class ServiceCallReportStep2Event extends Equatable {
  const ServiceCallReportStep2Event();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep2PostEvent extends ServiceCallReportStep2Event {
  final ServiceCallReportStep2Params params;

  const ServiceCallReportStep2PostEvent(this.params);

  @override
  List<Object?> get props => [params];
}
