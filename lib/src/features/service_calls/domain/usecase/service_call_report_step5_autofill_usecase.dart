import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step5_model/servicecall_report_step5_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep5AutoFillUsecase
    implements UseCase<ServiceCallStep5Response, ServiceCallReportStep5AutoFillParams> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep5AutoFillUsecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep5Response>> call(
      ServiceCallReportStep5AutoFillParams params) async {
    return await repository.serviceCallReportStep5AutoFill(
      params.reportId,
    );
  }
}

class ServiceCallReportStep5AutoFillParams extends Equatable {
  final String reportId;
  const ServiceCallReportStep5AutoFillParams(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
