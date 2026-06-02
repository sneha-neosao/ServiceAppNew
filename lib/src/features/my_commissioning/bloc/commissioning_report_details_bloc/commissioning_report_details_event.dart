import 'package:equatable/equatable.dart';

sealed class CommissioningReportDetailsEvent extends Equatable {
  const CommissioningReportDetailsEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningReportDetailsGetEvent
    extends CommissioningReportDetailsEvent {
  final String reportId;
  const CommissioningReportDetailsGetEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
