import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/delete_account_model/delete_account_response.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitialState extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {
  final DeleteAccountResponse data;

  const DeleteAccountSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteAccountFailureState extends DeleteAccountState {
  final String message;

  const DeleteAccountFailureState(this.message);

  @override
  List<Object> get props => [message];
}
