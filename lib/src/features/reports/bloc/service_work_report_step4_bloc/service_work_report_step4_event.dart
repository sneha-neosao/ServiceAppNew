import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step4_usecase.dart';

abstract class ServiceWorkReportStep4Event extends Equatable {
  const ServiceWorkReportStep4Event();

  @override
  List<Object?> get props => [];
}

class PostServiceWorkReportStep4Event extends ServiceWorkReportStep4Event {
  final ServiceWorkReportStep4Params params;

  const PostServiceWorkReportStep4Event({required this.params});

  @override
  List<Object?> get props => [params];
}
