import 'package:equatable/equatable.dart';

abstract class CheckFeedbackEvent extends Equatable {
  const CheckFeedbackEvent();

  @override
  List<Object?> get props => [];
}

class FetchCheckFeedbackEvent extends CheckFeedbackEvent {
  final String reportId;

  const FetchCheckFeedbackEvent({required this.reportId});

  @override
  List<Object?> get props => [reportId];
}
