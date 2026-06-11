import 'package:equatable/equatable.dart';

import '../../../../../../src/remote/models/amc_report_model/delete_amc_report_response.dart';

abstract class DeleteAmcReportState extends Equatable {
  const DeleteAmcReportState();

  @override
  List<Object> get props => [];
}

class DeleteAmcReportInitialState extends DeleteAmcReportState {}

class DeleteAmcReportLoadingState extends DeleteAmcReportState {}

class DeleteAmcReportSuccessState extends DeleteAmcReportState {
  final DeleteAmcReportResponse data;

  const DeleteAmcReportSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteAmcReportFailureState extends DeleteAmcReportState {
  final String message;

  const DeleteAmcReportFailureState(this.message);

  @override
  List<Object> get props => [message];
}
