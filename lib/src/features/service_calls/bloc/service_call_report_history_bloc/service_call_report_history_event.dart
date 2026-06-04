import 'package:equatable/equatable.dart';

abstract class ServiceCallReportHistoryEvent extends Equatable {
  const ServiceCallReportHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchServiceCallReportHistory extends ServiceCallReportHistoryEvent {}
