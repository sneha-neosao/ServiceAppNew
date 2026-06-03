import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';

abstract class ActiveTechniciansServiceCallsState extends Equatable {
  const ActiveTechniciansServiceCallsState();

  @override
  List<Object?> get props => [];
}

class ActiveTechniciansServiceCallsInitialState
    extends ActiveTechniciansServiceCallsState {}

class ActiveTechniciansServiceCallsLoadingState
    extends ActiveTechniciansServiceCallsState {}

class ActiveTechniciansServiceCallsSuccessState
    extends ActiveTechniciansServiceCallsState {
  final ActiveTechniciansServiceCallsResponse data;

  const ActiveTechniciansServiceCallsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ActiveTechniciansServiceCallsFailureState
    extends ActiveTechniciansServiceCallsState {
  final String message;

  const ActiveTechniciansServiceCallsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
