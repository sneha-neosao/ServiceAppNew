import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step2_response.dart';

abstract class AmcReportStep2AutofillState extends Equatable {
  const AmcReportStep2AutofillState();

  @override
  List<Object?> get props => [];
}

class AmcReportStep2AutofillInitialState extends AmcReportStep2AutofillState {}

class AmcReportStep2AutofillLoadingState extends AmcReportStep2AutofillState {}

class AmcReportStep2AutofillSuccessState extends AmcReportStep2AutofillState {
  final AmcReportStep2Response data;

  const AmcReportStep2AutofillSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AmcReportStep2AutofillFailureState extends AmcReportStep2AutofillState {
  final String message;

  const AmcReportStep2AutofillFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
