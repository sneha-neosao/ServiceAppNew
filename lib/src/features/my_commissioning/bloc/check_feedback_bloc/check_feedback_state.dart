import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/feedback_model/feedback_response.dart';

abstract class CheckFeedbackState extends Equatable {
  const CheckFeedbackState();

  @override
  List<Object?> get props => [];
}

class CheckFeedbackInitial extends CheckFeedbackState {}

class CheckFeedbackLoading extends CheckFeedbackState {}

class CheckFeedbackLoaded extends CheckFeedbackState {
  final FeedbackResponse response;

  const CheckFeedbackLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class CheckFeedbackError extends CheckFeedbackState {
  final String message;

  const CheckFeedbackError({required this.message});

  @override
  List<Object?> get props => [message];
}
