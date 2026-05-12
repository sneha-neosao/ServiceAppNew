import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';

/// Domain layer use case for verifying user and login

class LoginUseCase implements UseCase<LoginResponse, LoginParams> {

  final Repository _authRepository;
  const LoginUseCase(this._authRepository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginParams params) async {

    if (params.email.isEmpty) {
      return Left(EmptyFailure("please_enter_email".tr()));
    }

    if (params.password.isEmpty) {
      return Left(EmptyFailure("please_enter_password".tr()));
    }

    if (params.email.isEmailValid) {
      return Left(EmptyFailure("please_enter_valid_email".tr()));
    }

    final result = await _authRepository.login(params);

    return result;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [
    email,
    password
  ];
}
