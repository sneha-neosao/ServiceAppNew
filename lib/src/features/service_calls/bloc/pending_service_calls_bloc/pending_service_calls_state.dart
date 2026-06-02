import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_calls_model/pending_serbice_calls_response.dart';

sealed class PendingServiceCallsState extends Equatable {
  const PendingServiceCallsState();

  @override
  List<Object?> get props => [];
}

class PendingServiceCallsInitialState extends PendingServiceCallsState {}

class PendingServiceCallsLoadingState extends PendingServiceCallsState {}

class PendingServiceCallsPaginationLoadingState extends PendingServiceCallsState {
  final PendingServiceCallsResponse currentData;
  const PendingServiceCallsPaginationLoadingState(this.currentData);

  @override
  List<Object?> get props => [currentData];
}

class PendingServiceCallsSuccessState extends PendingServiceCallsState {
  final PendingServiceCallsResponse data;

  const PendingServiceCallsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PendingServiceCallsFailureState extends PendingServiceCallsState {
  final String message;

  const PendingServiceCallsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
