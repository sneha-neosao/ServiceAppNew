import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';

import '../../../../remote/models/commissioning_report_step1_model/commissioning_report_step1_autofill_response.dart';

/// Domain layer use case for verifying user and login

class CommissioningStep1AutofillUsecase
    implements
        UseCase<
          CommissioningReportStep1AutoFillResponse,
          CommissioningStep1AutofillParams
        > {
  final Repository _authRepository;
  const CommissioningStep1AutofillUsecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep1AutoFillResponse>> call(
    CommissioningStep1AutofillParams params,
  ) async {
    final result = await _authRepository.commissioning_report_step1_autofill(
      params,
    );

    return result;
  }
}

class CommissioningStep1AutofillParams extends Equatable {
  final String commissioning_report_id;

  const CommissioningStep1AutofillParams({
    required this.commissioning_report_id,
  });

  @override
  List<Object?> get props => [commissioning_report_id];
}
