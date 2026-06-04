import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_list_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';

/// Domain layer use case for fetching commissioning work

class CommissioningWorkListUseCase
    implements UseCase<CommissioningWorkListResponse, NoParams> {
  final Repository _authRepository;
  const CommissioningWorkListUseCase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningWorkListResponse>> call(
    NoParams params,
  ) async {
    final result = await _authRepository.commissioning_work_list(params);

    return result;
  }
}
