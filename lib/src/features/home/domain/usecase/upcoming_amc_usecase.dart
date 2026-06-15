import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/upcoming_amc_model/upcoming_amc_response.dart';

/// Domain layer use case for fetching upcoming amcs

class UpcomingAmcUseCase
    implements UseCase<UpcomingAmcVisitsResponse, UpcomingAmcParams> {
  final Repository _authRepository;
  const UpcomingAmcUseCase(this._authRepository);

  @override
  Future<Either<Failure, UpcomingAmcVisitsResponse>> call(
    UpcomingAmcParams params,
  ) async {
    final result = await _authRepository.upcoming_amc(params);

    return result;
  }
}

class UpcomingAmcParams extends Equatable {
  final String filter;
  final String? pending;

  const UpcomingAmcParams({required this.filter, this.pending});

  @override
  List<Object?> get props => [filter, pending];
}
