import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step2_response.dart';

abstract class AmcReportStep2State extends Equatable {
  const AmcReportStep2State();

  @override
  List<Object?> get props => [];
}

class AmcReportStep2InitialState extends AmcReportStep2State {}

class AmcReportStep2LoadingState extends AmcReportStep2State {}

class AmcReportStep2SuccessState extends AmcReportStep2State {
  final AmcReportStep2Response data;

  const AmcReportStep2SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcReportStep2ErrorState extends AmcReportStep2State {
  final String message;

  const AmcReportStep2ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
