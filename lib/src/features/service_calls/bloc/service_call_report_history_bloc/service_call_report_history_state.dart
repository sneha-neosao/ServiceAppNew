import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/servicecalls_report_history_model/servicecalls_report_history_response.dart';

abstract class ServiceCallReportHistoryState extends Equatable {
  const ServiceCallReportHistoryState();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportHistoryInitial extends ServiceCallReportHistoryState {}

class ServiceCallReportHistoryLoading extends ServiceCallReportHistoryState {}

class ServiceCallReportHistoryLoaded extends ServiceCallReportHistoryState {
  final ServiceCallReportResponse response;
  final int timestamp;

  ServiceCallReportHistoryLoaded({required this.response})
    : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [response, timestamp];
}

class ServiceCallReportHistoryError extends ServiceCallReportHistoryState {
  final String message;

  const ServiceCallReportHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
