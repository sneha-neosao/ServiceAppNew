import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';

abstract class ServiceCallReportStep3Event extends Equatable {
  const ServiceCallReportStep3Event();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep3PostEvent extends ServiceCallReportStep3Event {
  final ServiceCallReportStep3Params params;

  const ServiceCallReportStep3PostEvent(this.params);

  @override
  List<Object?> get props => [params];
}
