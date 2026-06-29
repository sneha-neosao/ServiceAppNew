import 'package:equatable/equatable.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step2_response.dart';

class PostAmcReportStep2Params extends Equatable {
  final String id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineHydraulicChecklistNa;
  final bool isElectricalChecklistNa;
  final bool operationChecklistNa;
  final String mechanicalChecklist;
  final String pipelineHydraulicChecklist;
  final String electricalChecklist;
  final String operationChecklist;

  const PostAmcReportStep2Params({
    required this.id,
    required this.isMechanicalChecklistNa,
    required this.isPipelineHydraulicChecklistNa,
    required this.isElectricalChecklistNa,
    required this.operationChecklistNa,
    required this.mechanicalChecklist,
    required this.pipelineHydraulicChecklist,
    required this.electricalChecklist,
    required this.operationChecklist,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "is_mechanical_checklist_na": isMechanicalChecklistNa,
      "is_pipeline_hydraulic_checklist_na": isPipelineHydraulicChecklistNa,
      "is_electrical_checklist_na": isElectricalChecklistNa,
      "operation_checklist_na": operationChecklistNa,
      "mechanical_checklist": mechanicalChecklist,
      "Pipeline_Hydraulic_checklist": pipelineHydraulicChecklist,
      "electrical_checklist": electricalChecklist,
      "operation_checklist": operationChecklist,
    };
  }

  @override
  List<Object?> get props => [
    id,
    isMechanicalChecklistNa,
    isPipelineHydraulicChecklistNa,
    isElectricalChecklistNa,
    operationChecklistNa,
    mechanicalChecklist,
    pipelineHydraulicChecklist,
    electricalChecklist,
    operationChecklist,
  ];
}

class PostAmcReportStep2Usecase
    implements UseCase<AmcReportStep2Response, PostAmcReportStep2Params> {
  final Repository repository;

  PostAmcReportStep2Usecase(this.repository);

  @override
  Future<Either<Failure, AmcReportStep2Response>> call(
    PostAmcReportStep2Params params,
  ) async {
    return await repository.amcReportStep2(params);
  }
}
