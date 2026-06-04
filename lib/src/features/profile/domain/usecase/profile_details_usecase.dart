import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';

/// Domain layer use case for fetching profile details

class ProfileDetailsUseCase
    implements UseCase<ProfileDetailsResponse, NoParams> {
  final Repository _authRepository;
  const ProfileDetailsUseCase(this._authRepository);

  @override
  Future<Either<Failure, ProfileDetailsResponse>> call(NoParams params) async {
    final result = await _authRepository.profile_details(params);

    return result;
  }
}
