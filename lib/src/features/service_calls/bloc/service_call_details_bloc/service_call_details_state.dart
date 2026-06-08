import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_calls_details_model/service_calls_details_response.dart';

sealed class ServiceCallDetailsState extends Equatable {
  const ServiceCallDetailsState();

  @override
  List<Object?> get props => [];
}

class ServiceCallDetailsInitialState extends ServiceCallDetailsState {}

class ServiceCallDetailsLoadingState extends ServiceCallDetailsState {}

class ServiceCallDetailsSuccessState extends ServiceCallDetailsState {
  final ServiceCallDetailsResponse data;

  const ServiceCallDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ServiceCallDetailsFailureState extends ServiceCallDetailsState {
  final String message;

  const ServiceCallDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
