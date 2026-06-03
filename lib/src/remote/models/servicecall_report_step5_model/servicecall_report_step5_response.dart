class ServiceCallStep5Response {
  final int status;
  final bool success;
  final ServiceCallStep5Data data;
  final String message;

  ServiceCallStep5Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceCallStep5Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep5Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceCallStep5Data.fromJson(json['data'] ?? {}),
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
}

class ServiceCallStep5Data {
  final String id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<SavedChecklist> savedChecklists;
  final int lastCompletedStep;

  ServiceCallStep5Data({
    required this.id,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.savedChecklists,
    required this.lastCompletedStep,
  });

  factory ServiceCallStep5Data.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep5Data(
      id: json['id'] ?? '',
      isMechanicalChecklistNa: json['is_mechanical_checklist_na'] ?? false,
      isPipelineChecklistNa: json['is_pipeline_checklist_na'] ?? false,
      isElectricalChecklistNa: json['is_electrical_checklist_na'] ?? false,
      savedChecklists: (json['checklist_items'] as List<dynamic>?)
              ?.map((e) => SavedChecklist.fromJson(e))
              .toList() ??
          [],
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_mechanical_checklist_na': isMechanicalChecklistNa,
      'is_pipeline_checklist_na': isPipelineChecklistNa,
      'is_electrical_checklist_na': isElectricalChecklistNa,
      'checklist_items': savedChecklists.map((e) => e.toJson()).toList(),
      'last_completed_step': lastCompletedStep,
    };
  }
}

class SavedChecklist {
  final String id;
  final String checkType;
  final String keyChecklist;
  final String valueChecklist;
  final String? photo;
  final String? video;

  SavedChecklist({
    required this.id,
    required this.checkType,
    required this.keyChecklist,
    required this.valueChecklist,
    this.photo,
    this.video,
  });

  factory SavedChecklist.fromJson(Map<String, dynamic> json) {
    return SavedChecklist(
      id: json['id']?.toString() ?? '',
      checkType: json['check_type'] ?? '',
      keyChecklist: json['key_checklist'] ?? '',
      valueChecklist: json['value_checklist'] ?? '',
      photo: json['photo'],
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'check_type': checkType,
      'key_checklist': keyChecklist,
      'value_checklist': valueChecklist,
      if (photo != null) 'photo': photo,
      if (video != null) 'video': video,
    };
  }
}
