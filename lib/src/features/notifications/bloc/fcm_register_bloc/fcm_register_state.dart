import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/auth_model/fcm_register_response.dart';

abstract class FcmRegisterState extends Equatable {
  const FcmRegisterState();

  @override
  List<Object> get props => [];
}

class FcmRegisterInitial extends FcmRegisterState {}

class FcmRegisterLoading extends FcmRegisterState {}

class FcmRegisterSuccess extends FcmRegisterState {
  final FcmRegisterResponse response;

  const FcmRegisterSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class FcmRegisterFailure extends FcmRegisterState {
  final String message;

  const FcmRegisterFailure(this.message);

  @override
  List<Object> get props => [message];
}
