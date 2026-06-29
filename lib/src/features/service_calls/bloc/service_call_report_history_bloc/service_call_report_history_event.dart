import 'package:equatable/equatable.dart';

abstract class ServiceCallReportHistoryEvent extends Equatable {
  const ServiceCallReportHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchServiceCallReportHistory extends ServiceCallReportHistoryEvent {
  final String? customerId;
  final String? siteId;
  final String? date;
  final String? startDate;
  final String? endDate;
  final int? page;
  final int? pageSize;
  final String? search;
  final String? reportType;

  const FetchServiceCallReportHistory({
    this.customerId,
    this.siteId,
    this.date,
    this.startDate,
    this.endDate,
    this.page,
    this.pageSize,
    this.search,
    this.reportType,
  });

  @override
  List<Object?> get props => [
    customerId,
    siteId,
    date,
    startDate,
    endDate,
    page,
    pageSize,
    search,
    reportType,
  ];
}
