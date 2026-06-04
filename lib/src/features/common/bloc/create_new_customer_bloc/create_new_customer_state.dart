import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/create_new_customer_model/create_new_customer_response.dart';

abstract class CreateNewCustomerState extends Equatable {
  const CreateNewCustomerState();

  @override
  List<Object?> get props => [];
}

class CreateNewCustomerInitialState extends CreateNewCustomerState {}

class CreateNewCustomerLoadingState extends CreateNewCustomerState {}

class CreateNewCustomerSuccessState extends CreateNewCustomerState {
  final AddCustomerResponse data;

  const CreateNewCustomerSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CreateNewCustomerFailureState extends CreateNewCustomerState {
  final String message;

  const CreateNewCustomerFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
