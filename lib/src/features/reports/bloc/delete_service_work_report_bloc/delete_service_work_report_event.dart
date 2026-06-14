import 'package:equatable/equatable.dart';

abstract class DeleteServiceWorkReportEvent extends Equatable {
  const DeleteServiceWorkReportEvent();

  @override
  List<Object?> get props => [];
}

class DeleteDraftServiceWorkReportEvent extends DeleteServiceWorkReportEvent {
  final String reportId;

  const DeleteDraftServiceWorkReportEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
