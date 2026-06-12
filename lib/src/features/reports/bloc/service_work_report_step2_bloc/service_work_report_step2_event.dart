import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step2_usecase.dart';

abstract class ServiceWorkReportStep2Event extends Equatable {
  const ServiceWorkReportStep2Event();

  @override
  List<Object> get props => [];
}

class PostServiceWorkReportStep2Event extends ServiceWorkReportStep2Event {
  final ServiceWorkReportStep2Params params;

  const PostServiceWorkReportStep2Event(this.params);

  @override
  List<Object> get props => [params];
}
