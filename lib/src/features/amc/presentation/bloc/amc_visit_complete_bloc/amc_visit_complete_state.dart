import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_visit_complete_response.dart';

abstract class AmcVisitCompleteState extends Equatable {
  const AmcVisitCompleteState();

  @override
  List<Object> get props => [];
}

class AmcVisitCompleteInitialState extends AmcVisitCompleteState {}

class AmcVisitCompleteLoadingState extends AmcVisitCompleteState {}

class AmcVisitCompleteSuccessState extends AmcVisitCompleteState {
  final AmcVisitCompleteResponse data;

  const AmcVisitCompleteSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class AmcVisitCompleteFailureState extends AmcVisitCompleteState {
  final String message;

  const AmcVisitCompleteFailureState(this.message);

  @override
  List<Object> get props => [message];
}
