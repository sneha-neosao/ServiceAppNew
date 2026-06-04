import 'package:equatable/equatable.dart';

enum PdfAction { download, view }

abstract class CommissioningReportPdfEvent extends Equatable {
  const CommissioningReportPdfEvent();

  @override
  List<Object> get props => [];
}

class FetchCommissioningReportPdfEvent extends CommissioningReportPdfEvent {
  final String reportId;
  final PdfAction action;

  const FetchCommissioningReportPdfEvent({
    required this.reportId,
    required this.action,
  });

  @override
  List<Object> get props => [reportId, action];
}
