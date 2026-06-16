import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationsEvent {
  final int page;
  final bool isRefresh;
  final String? customerName;
  final String? siteName;
  final String? date;

  const GetNotificationsEvent({
    this.page = 1,
    this.isRefresh = false,
    this.customerName,
    this.siteName,
    this.date,
  });

  @override
  List<Object?> get props => [page, isRefresh, customerName, siteName, date];
}
