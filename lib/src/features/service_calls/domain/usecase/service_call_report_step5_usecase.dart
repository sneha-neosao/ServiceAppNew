import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step5_model/servicecall_report_step5_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep5Usecase
    implements UseCase<ServiceCallStep5Response, ServiceCallReportStep5Params> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep5Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep5Response>> call(
      ServiceCallReportStep5Params params) async {
    return await repository.serviceCallReportStep5(
      params.reportId,
      params.isMechanicalChecklistNa,
      params.isPipelineChecklistNa,
      params.isElectricalChecklistNa,
      params.checklistItems,
    );
  }
}

class ServiceCallReportStep5Params {
  final String reportId;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<Map<String, dynamic>> checklistItems;

  ServiceCallReportStep5Params({
    required this.reportId,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.checklistItems,
  });
}
