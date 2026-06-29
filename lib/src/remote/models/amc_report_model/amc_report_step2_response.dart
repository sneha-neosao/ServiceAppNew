import 'dart:convert';
import 'package:equatable/equatable.dart';

class AmcReportStep2Response extends Equatable {
  final int status;
  final bool success;
  final AmcReportStep2Data data;
  final String message;

  const AmcReportStep2Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcReportStep2Response.fromJson(Map<String, dynamic> json) {
    return AmcReportStep2Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: AmcReportStep2Data.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data.toJson(),
      'message': message,
    };
  }

  @override
  List<Object?> get props => [status, success, data, message];
}

class AmcReportStep2Data extends Equatable {
  final String id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineHydraulicChecklistNa;
  final bool isElectricalChecklistNa;
  final bool operationChecklistNa;
  final String mechanicalChecklist;
  final String pipelineHydraulicChecklist;
  final String electricalChecklist;
  final String operationChecklist;

  const AmcReportStep2Data({
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

  factory AmcReportStep2Data.fromJson(Map<String, dynamic> json) {
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return jsonEncode(value);
    }

    return AmcReportStep2Data(
      id: json['id']?.toString() ?? '',
      isMechanicalChecklistNa: json['is_mechanical_checklist_na'] ?? false,
      isPipelineHydraulicChecklistNa: json['is_pipeline_hydraulic_checklist_na'] ?? false,
      isElectricalChecklistNa: json['is_electrical_checklist_na'] ?? false,
      operationChecklistNa: json['operation_checklist_na'] ?? false,
      mechanicalChecklist: safeString(json['mechanical_checklist']),
      pipelineHydraulicChecklist: safeString(json['Pipeline_Hydraulic_checklist']),
      electricalChecklist: safeString(json['electrical_checklist']),
      operationChecklist: safeString(json['operation_checklist']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_mechanical_checklist_na': isMechanicalChecklistNa,
      'is_pipeline_hydraulic_checklist_na': isPipelineHydraulicChecklistNa,
      'is_electrical_checklist_na': isElectricalChecklistNa,
      'operation_checklist_na': operationChecklistNa,
      'mechanical_checklist': mechanicalChecklist,
      'Pipeline_Hydraulic_checklist': pipelineHydraulicChecklist,
      'electrical_checklist': electricalChecklist,
      'operation_checklist': operationChecklist,
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
