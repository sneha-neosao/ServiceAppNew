import 'package:equatable/equatable.dart';

sealed class PendingServiceCallsEvent extends Equatable {
  const PendingServiceCallsEvent();

  @override
  List<Object?> get props => [];
}

class PendingServiceCallsGetEvent extends PendingServiceCallsEvent {
  final int page;
  final int pageSize;
  final String? customerId;
  final String? siteId;
  final String? customerName;
  final String? siteName;
  final String? complaintNumber;
  final String? date;
  final bool isRefresh;

  const PendingServiceCallsGetEvent({
    this.page = 1,
    this.pageSize = 10,
    this.customerId,
    this.siteId,
    this.customerName,
    this.siteName,
    this.complaintNumber,
    this.date,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [
    page,
    pageSize,
    customerId,
    siteId,
    customerName,
    siteName,
    complaintNumber,
    date,
    isRefresh,
  ];
}
