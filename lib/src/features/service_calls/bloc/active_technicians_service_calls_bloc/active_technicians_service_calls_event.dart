import 'package:equatable/equatable.dart';

abstract class ActiveTechniciansServiceCallsEvent extends Equatable {
  const ActiveTechniciansServiceCallsEvent();

  @override
  List<Object?> get props => [];
}

class ActiveTechniciansServiceCallsGetEvent
    extends ActiveTechniciansServiceCallsEvent {
  const ActiveTechniciansServiceCallsGetEvent();
}
