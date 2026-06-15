import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/app_settings_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetAppSettingsUseCase implements UseCase<AppSettingsResponse, NoParams> {
  final Repository _repository;

  const GetAppSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, AppSettingsResponse>> call(NoParams params) async {
    return await _repository.getAppSettings();
  }
}
