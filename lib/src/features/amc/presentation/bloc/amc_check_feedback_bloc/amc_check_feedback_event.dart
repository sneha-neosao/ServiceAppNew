import 'package:equatable/equatable.dart';

abstract class AmcCheckFeedbackEvent extends Equatable {
  const AmcCheckFeedbackEvent();

  @override
  List<Object> get props => [];
}

class CheckAmcFeedbackEvent extends AmcCheckFeedbackEvent {
  final String amcVisitId;

  const CheckAmcFeedbackEvent({required this.amcVisitId});

  @override
  List<Object> get props => [amcVisitId];
}
