import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/assigned_technician_representative_model/assigned_technician_representative_response.dart';

class ServiceWorkReportTechniciansUsecase
    implements
        UseCase<
          AssignedTechnicianResponse,
          ServiceWorkReportTechniciansParams
        > {
  final Repository _authRepository;

  const ServiceWorkReportTechniciansUsecase(this._authRepository);

  @override
  Future<Either<Failure, AssignedTechnicianResponse>> call(
    ServiceWorkReportTechniciansParams params,
  ) async {
    return await _authRepository.serviceWorkReportTechnicians(params.reportId);
  }
}

class ServiceWorkReportTechniciansParams extends Equatable {
  final String reportId;

  const ServiceWorkReportTechniciansParams(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
