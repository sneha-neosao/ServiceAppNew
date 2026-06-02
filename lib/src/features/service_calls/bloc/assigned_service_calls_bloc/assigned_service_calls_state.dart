import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_calls_model/assigned_service_calls_response.dart';

sealed class AssignedServiceCallsState extends Equatable {
  const AssignedServiceCallsState();

  @override
  List<Object?> get props => [];
}

class AssignedServiceCallsInitialState extends AssignedServiceCallsState {}

class AssignedServiceCallsLoadingState extends AssignedServiceCallsState {}

class AssignedServiceCallsPaginationLoadingState extends AssignedServiceCallsState {
  final AssignedServiceCallsResponse currentData;
  const AssignedServiceCallsPaginationLoadingState(this.currentData);

  @override
  List<Object?> get props => [currentData];
}

class AssignedServiceCallsSuccessState extends AssignedServiceCallsState {
  final AssignedServiceCallsResponse data;

  const AssignedServiceCallsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AssignedServiceCallsFailureState extends AssignedServiceCallsState {
  final String message;

  const AssignedServiceCallsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
