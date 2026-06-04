import 'package:equatable/equatable.dart';

abstract class ServiceCallCheckFeedbackEvent extends Equatable {
  const ServiceCallCheckFeedbackEvent();

  @override
  List<Object> get props => [];
}

class FetchServiceCallCheckFeedbackEvent extends ServiceCallCheckFeedbackEvent {
  final String reportId;

  const FetchServiceCallCheckFeedbackEvent({required this.reportId});

  @override
  List<Object> get props => [reportId];
}
