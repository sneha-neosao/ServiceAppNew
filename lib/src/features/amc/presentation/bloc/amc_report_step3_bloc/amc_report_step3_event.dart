import 'package:equatable/equatable.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step3_usecase.dart';

abstract class AmcReportStep3Event extends Equatable {
  const AmcReportStep3Event();

  @override
  List<Object?> get props => [];
}

class PostAmcReportStep3Event extends AmcReportStep3Event {
  final PostAmcReportStep3Params params;

  const PostAmcReportStep3Event(this.params);

  @override
  List<Object?> get props => [params];
}
