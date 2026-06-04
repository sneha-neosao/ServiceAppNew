import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/feedback_model/feedback_response.dart';

abstract class ServiceCallCheckFeedbackState extends Equatable {
  const ServiceCallCheckFeedbackState();

  @override
  List<Object?> get props => [];
}

class ServiceCallCheckFeedbackInitial extends ServiceCallCheckFeedbackState {}

class ServiceCallCheckFeedbackLoading extends ServiceCallCheckFeedbackState {}

class ServiceCallCheckFeedbackLoaded extends ServiceCallCheckFeedbackState {
  final FeedbackResponse response;

  const ServiceCallCheckFeedbackLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class ServiceCallCheckFeedbackError extends ServiceCallCheckFeedbackState {
  final String message;

  const ServiceCallCheckFeedbackError(this.message);

  @override
  List<Object?> get props => [message];
}
