import 'package:equatable/equatable.dart';

abstract class AmcVisitCompleteEvent extends Equatable {
  const AmcVisitCompleteEvent();

  @override
  List<Object> get props => [];
}

class SubmitAmcVisitCompleteEvent extends AmcVisitCompleteEvent {
  final String visitId;

  const SubmitAmcVisitCompleteEvent({required this.visitId});

  @override
  List<Object> get props => [visitId];
}
