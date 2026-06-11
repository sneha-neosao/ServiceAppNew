import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/feedback_model/feedback_response.dart';

abstract class AmcCheckFeedbackState extends Equatable {
  const AmcCheckFeedbackState();

  @override
  List<Object> get props => [];
}

class AmcCheckFeedbackInitialState extends AmcCheckFeedbackState {}

class AmcCheckFeedbackLoadingState extends AmcCheckFeedbackState {}

class AmcCheckFeedbackSuccessState extends AmcCheckFeedbackState {
  final FeedbackResponse data;

  const AmcCheckFeedbackSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class AmcCheckFeedbackFailureState extends AmcCheckFeedbackState {
  final String message;

  const AmcCheckFeedbackFailureState(this.message);

  @override
  List<Object> get props => [message];
}
