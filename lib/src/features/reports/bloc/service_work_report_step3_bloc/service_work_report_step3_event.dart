import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step3_usecase.dart';

abstract class ServiceWorkReportStep3Event extends Equatable {
  const ServiceWorkReportStep3Event();

  @override
  List<Object> get props => [];
}

class PostServiceWorkReportStep3Event extends ServiceWorkReportStep3Event {
  final ServiceWorkReportStep3Params params;

  const PostServiceWorkReportStep3Event(this.params);

  @override
  List<Object> get props => [params];
}
