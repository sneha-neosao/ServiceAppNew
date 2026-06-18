import 'package:equatable/equatable.dart';

abstract class DeleteAmcReportEvent extends Equatable {
  const DeleteAmcReportEvent();

  @override
  List<Object> get props => [];
}

class DeleteAmcReportSubmitEvent extends DeleteAmcReportEvent {
  final String reportId;

  const DeleteAmcReportSubmitEvent(this.reportId);

  @override
  List<Object> get props => [reportId];
}
