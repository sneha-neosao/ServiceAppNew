import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/fcm_register_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class FcmRegisterUseCase
    implements UseCase<FcmRegisterResponse, FcmRegisterParams> {
  final Repository _repository;

  const FcmRegisterUseCase(this._repository);

  @override
  Future<Either<Failure, FcmRegisterResponse>> call(
    FcmRegisterParams params,
  ) async {
    return await _repository.fcmRegister(params.fcmToken);
  }
}

class FcmRegisterParams extends Equatable {
  final String fcmToken;

  const FcmRegisterParams({required this.fcmToken});

  @override
  List<Object?> get props => [fcmToken];
}
