import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step1_usecase.dart';

abstract class ServiceWorkReportStep1Event extends Equatable {
  const ServiceWorkReportStep1Event();

  @override
  List<Object?> get props => [];
}

class PostServiceWorkReportStep1Event extends ServiceWorkReportStep1Event {
  final ServiceWorkReportStep1Params params;

  const PostServiceWorkReportStep1Event(this.params);

  @override
  List<Object?> get props => [params];
}
