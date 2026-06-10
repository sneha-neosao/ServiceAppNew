import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step1_response.dart';

abstract class AmcReportStep1AutofillState extends Equatable {
  const AmcReportStep1AutofillState();

  @override
  List<Object?> get props => [];
}

class AmcReportStep1AutofillInitialState extends AmcReportStep1AutofillState {}

class AmcReportStep1AutofillLoadingState extends AmcReportStep1AutofillState {}

class AmcReportStep1AutofillSuccessState extends AmcReportStep1AutofillState {
  final AmcReportStep1Response data;

  const AmcReportStep1AutofillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcReportStep1AutofillFailureState extends AmcReportStep1AutofillState {
  final String message;

  const AmcReportStep1AutofillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
