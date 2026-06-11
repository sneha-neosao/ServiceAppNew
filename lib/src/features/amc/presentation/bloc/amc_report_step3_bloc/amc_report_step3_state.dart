import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step3_response.dart';

abstract class AmcReportStep3State extends Equatable {
  const AmcReportStep3State();

  @override
  List<Object?> get props => [];
}

class AmcReportStep3InitialState extends AmcReportStep3State {}

class AmcReportStep3LoadingState extends AmcReportStep3State {}

class AmcReportStep3SuccessState extends AmcReportStep3State {
  final AmcReportStep3Response data;

  const AmcReportStep3SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcReportStep3ErrorState extends AmcReportStep3State {
  final String message;

  const AmcReportStep3ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
