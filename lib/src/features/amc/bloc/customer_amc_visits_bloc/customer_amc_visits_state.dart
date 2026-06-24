import 'package:equatable/equatable.dart';

import 'package:service_app/src/remote/models/amc_visit_model/customer_amc_visits_response.dart';

abstract class CustomerAmcVisitsState extends Equatable {
  const CustomerAmcVisitsState();

  @override
  List<Object?> get props => [];
}

class CustomerAmcVisitsInitial extends CustomerAmcVisitsState {}

class CustomerAmcVisitsLoading extends CustomerAmcVisitsState {}

class CustomerAmcVisitsSuccess extends CustomerAmcVisitsState {
  final CustomerAmcVisitsResponse response;

  const CustomerAmcVisitsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CustomerAmcVisitsError extends CustomerAmcVisitsState {
  final String message;

  const CustomerAmcVisitsError(this.message);

  @override
  List<Object?> get props => [message];
}
