import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';

/// Domain layer use case for fetching sites

class SitesUseCase implements UseCase<SiteResponse, SitesParams> {
  final Repository _authRepository;
  const SitesUseCase(this._authRepository);

  @override
  Future<Either<Failure, SiteResponse>> call(SitesParams params) async {
    final result = await _authRepository.sites(params);

    return result;
  }
}

class SitesParams extends Equatable {
  final String customer_id;

  const SitesParams({required this.customer_id});

  @override
  List<Object?> get props => [customer_id];
}
