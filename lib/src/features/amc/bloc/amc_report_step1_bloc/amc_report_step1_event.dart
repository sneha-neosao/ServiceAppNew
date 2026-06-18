import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step1_usecase.dart';

abstract class AmcReportStep1Event extends Equatable {
  const AmcReportStep1Event();

  @override
  List<Object?> get props => [];
}

class PostAmcReportStep1Event extends AmcReportStep1Event {
  final PostAmcReportStep1Params params;

  const PostAmcReportStep1Event(this.params);

  @override
  List<Object?> get props => [params];
}
