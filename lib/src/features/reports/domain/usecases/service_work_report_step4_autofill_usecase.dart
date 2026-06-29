import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step4_model/service_work_report_step4_response.dart';

class ServiceWorkReportStep4AutoFillUsecase
    implements
        UseCase<
          ServiceWorkReportStep4Response,
          ServiceWorkReportStep4AutoFillParams
        > {
  final Repository _authRepository;

  const ServiceWorkReportStep4AutoFillUsecase(this._authRepository);

  @override
  Future<Either<Failure, ServiceWorkReportStep4Response>> call(
    ServiceWorkReportStep4AutoFillParams params,
  ) async {
    return await _authRepository.serviceWorkReportStep4AutoFill(params.reportId);
  }
}

class ServiceWorkReportStep4AutoFillParams extends Equatable {
  final String reportId;

  const ServiceWorkReportStep4AutoFillParams(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
