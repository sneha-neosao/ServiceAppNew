class ServiceWorkReportStep3Response {
  final int status;
  final bool success;
  final ServiceWorkReportStep3Data data;
  final String message;

  ServiceWorkReportStep3Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceWorkReportStep3Response.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep3Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceWorkReportStep3Data.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class ServiceWorkReportStep3Data {
  final String id;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<ServiceWorkSavedChecklist> savedChecklists;
  final int lastCompletedStep;

  ServiceWorkReportStep3Data({
    required this.id,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.savedChecklists,
    required this.lastCompletedStep,
  });

  factory ServiceWorkReportStep3Data.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep3Data(
      id: json['id']?.toString() ?? '',
      isMechanicalChecklistNa: json['is_mechanical_checklist_na'] ?? false,
      isPipelineChecklistNa: json['is_pipeline_checklist_na'] ?? false,
      isElectricalChecklistNa: json['is_electrical_checklist_na'] ?? false,
      savedChecklists:
          (json['saved_checklists'] as List<dynamic>?)
              ?.map(
                (e) => ServiceWorkSavedChecklist.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }
}

class ServiceWorkSavedChecklist {
  final String id;
  final String checkType;
  final String keyChecklist;
  final String valueChecklist;
  final String photo;
  final String video;

  ServiceWorkSavedChecklist({
    required this.id,
    required this.checkType,
    required this.keyChecklist,
    required this.valueChecklist,
    required this.photo,
    required this.video,
  });

  factory ServiceWorkSavedChecklist.fromJson(Map<String, dynamic> json) {
    return ServiceWorkSavedChecklist(
      id: json['id']?.toString() ?? '',
      checkType: json['check_type']?.toString() ?? '',
      keyChecklist: json['key_checklist']?.toString() ?? '',
      valueChecklist: json['value_checklist']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      video: json['video']?.toString() ?? '',
    );
  }
}

class ServiceWorkChecklistItem {
  final String checkType;
  final String keyChecklist;
  final String valueChecklist;
  final String? photo;
  final String? video;
  final String? existingPhotoUrl;
  final String? existingVideoUrl;

  ServiceWorkChecklistItem({
    required this.checkType,
    required this.keyChecklist,
    required this.valueChecklist,
    this.photo,
    this.video,
    this.existingPhotoUrl,
    this.existingVideoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'check_type': checkType,
      'key_checklist': keyChecklist,
      'value_checklist': valueChecklist,
      'photo': photo ?? '',
      'video': video ?? '',
      'existing_photo_url': existingPhotoUrl ?? '',
      'existing_video_url': existingVideoUrl ?? '',
    };
  }
}
