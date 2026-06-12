import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep3Params extends Equatable {
  final String id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<ServiceWorkChecklistItem> checklistItems;

  const ServiceWorkReportStep3Params({
    required this.id,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.checklistItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_mechanical_checklist_na': isMechanicalChecklistNa,
      'is_pipeline_checklist_na': isPipelineChecklistNa,
      'is_electrical_checklist_na': isElectricalChecklistNa,
      'checklist_items':
          checklistItems.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        isMechanicalChecklistNa,
        isPipelineChecklistNa,
        isElectricalChecklistNa,
        checklistItems,
      ];
}

class ServiceWorkReportStep3Usecase
    implements
        UseCase<ServiceWorkReportStep3Response, ServiceWorkReportStep3Params> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep3Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep3Response>> call(
    ServiceWorkReportStep3Params params,
  ) async {
    return await repository.serviceWorkReportStep3(params);
  }
}
