import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step1_response.dart';

abstract class AmcReportStep1State extends Equatable {
  const AmcReportStep1State();

  @override
  List<Object?> get props => [];
}

class AmcReportStep1InitialState extends AmcReportStep1State {}

class AmcReportStep1LoadingState extends AmcReportStep1State {}

class AmcReportStep1SuccessState extends AmcReportStep1State {
  final AmcReportStep1Response data;

  const AmcReportStep1SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcReportStep1FailureState extends AmcReportStep1State {
  final String message;

  const AmcReportStep1FailureState(this.message);

  @override
  List<Object?> get props => [message];
}
