import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';

/// Domain layer use case for fetching technician

class TechnicianUseCase implements UseCase<TechnicianResponse, NoParams> {

  final Repository _authRepository;
  const TechnicianUseCase(this._authRepository);

  @override
  Future<Either<Failure, TechnicianResponse>> call(NoParams params) async {

    final result = await _authRepository.technician(params);

    return result;
  }
}
