import 'package:equatable/equatable.dart';

sealed class AssignedServiceCallsEvent extends Equatable {
  const AssignedServiceCallsEvent();

  @override
  List<Object?> get props => [];
}

class AssignedServiceCallsGetEvent extends AssignedServiceCallsEvent {
  final int page;
  final int pageSize;
  final String? customerId;
  final String? siteId;
  final String? complaintNumber;
  final String? date;
  final bool isRefresh;

  const AssignedServiceCallsGetEvent({
    this.page = 1,
    this.pageSize = 10,
    this.customerId,
    this.siteId,
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
    complaintNumber,
    date,
    isRefresh,
  ];
}
