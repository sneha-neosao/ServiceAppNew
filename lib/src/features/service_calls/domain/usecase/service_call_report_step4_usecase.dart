import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step4_model/servicecall_report_step4_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep4Usecase
    implements UseCase<ServiceCallStep4Response, ServiceCallReportStep4Params> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep4Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep4Response>> call(
    ServiceCallReportStep4Params params,
  ) async {
    return await repository.serviceCallReportStep4(
      params.reportId,
      params.descriptions,
    );
  }
}

class ServiceCallReportStep4Params {
  final String reportId;
  final List<Map<String, dynamic>> descriptions;

  ServiceCallReportStep4Params({
    required this.reportId,
    required this.descriptions,
  });
}
