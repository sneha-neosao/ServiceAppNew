import 'package:equatable/equatable.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step2_usecase.dart';

abstract class AmcReportStep2Event extends Equatable {
  const AmcReportStep2Event();

  @override
  List<Object?> get props => [];
}

class PostAmcReportStep2Event extends AmcReportStep2Event {
  final PostAmcReportStep2Params params;

  const PostAmcReportStep2Event(this.params);

  @override
  List<Object?> get props => [params];
}
