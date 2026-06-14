import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/delete_service_work_report_model/delete_service_work_report_response.dart';

abstract class DeleteServiceWorkReportState extends Equatable {
  const DeleteServiceWorkReportState();

  @override
  List<Object?> get props => [];
}

class DeleteServiceWorkReportInitial extends DeleteServiceWorkReportState {}

class DeleteServiceWorkReportLoading extends DeleteServiceWorkReportState {}

class DeleteServiceWorkReportSuccess extends DeleteServiceWorkReportState {
  final DeleteServiceWorkReportResponse response;

  const DeleteServiceWorkReportSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class DeleteServiceWorkReportFailure extends DeleteServiceWorkReportState {
  final String message;

  const DeleteServiceWorkReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}
