import 'package:equatable/equatable.dart';

class CommissioningReportStep5AutoFillResponse extends Equatable {
  final int status;
  final bool success;
  final CommissioningStep5Data data;
  final String message;

  const CommissioningReportStep5AutoFillResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportStep5AutoFillResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningReportStep5AutoFillResponse(
      status: json['status'],
      success: json['success'],
      data: CommissioningStep5Data.fromJson(json['data']),
      message: json['message'],
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

class CommissioningStep5Data extends Equatable {
  final String id;
  final bool? isTechnicalNa;
  final Map<String, dynamic>? technicalDetails;
  final bool isMechanicalChecklistNa;
  final bool isPipelineChecklistNa;
  final bool isElectricalChecklistNa;
  final List<SavedChecklist> savedChecklists;
  final List<SavedDescription>? savedDescriptions;
  final int lastCompletedStep;

  const CommissioningStep5Data({
    required this.id,
    this.isTechnicalNa,
    this.technicalDetails,
    required this.isMechanicalChecklistNa,
    required this.isPipelineChecklistNa,
    required this.isElectricalChecklistNa,
    required this.savedChecklists,
    this.savedDescriptions,
    required this.lastCompletedStep,
  });

  factory CommissioningStep5Data.fromJson(Map<String, dynamic> json) {
    return CommissioningStep5Data(
      id: json['id'],
      isTechnicalNa: json['is_technical_na'],
      technicalDetails: json['technical_details'],
      isMechanicalChecklistNa: json['is_mechanical_checklist_na'],
      isPipelineChecklistNa: json['is_pipeline_checklist_na'],
      isElectricalChecklistNa: json['is_electrical_checklist_na'],
      savedChecklists: (json['saved_checklists'] as List)
          .map((e) => SavedChecklist.fromJson(e))
          .toList(),
      savedDescriptions: json['saved_descriptions'] != null
          ? (json['saved_descriptions'] as List)
          .map((e) => SavedDescription.fromJson(e))
          .toList()
          : null,
      lastCompletedStep: json['last_completed_step'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_technical_na': isTechnicalNa,
      'technical_details': technicalDetails ?? {},
      'is_mechanical_checklist_na': isMechanicalChecklistNa,
      'is_pipeline_checklist_na': isPipelineChecklistNa,
      'is_electrical_checklist_na': isElectricalChecklistNa,
      'saved_checklists': savedChecklists.map((e) => e.toJson()).toList(),
      'saved_descriptions':
      savedDescriptions?.map((e) => e.toJson()).toList() ?? [],
      'last_completed_step': lastCompletedStep,
    };
  }

  @override
  List<Object?> get props => [
    id,
    isTechnicalNa,
    technicalDetails,
    isMechanicalChecklistNa,
    isPipelineChecklistNa,
    isElectricalChecklistNa,
    savedChecklists,
    savedDescriptions,
    lastCompletedStep,
  ];
}

class SavedChecklist extends Equatable {
  final String id;
  final String checkType;
  final String keyChecklist;
  final String valueChecklist;
  final String? photo;
  final String? video;
  final String? existingPhotoUrl;
  final String? existingVideoUrl;

  const SavedChecklist({
    required this.id,
    required this.checkType,
    required this.keyChecklist,
    required this.valueChecklist,
    this.photo,
    this.video,
    this.existingPhotoUrl,
    this.existingVideoUrl,
  });

  factory SavedChecklist.fromJson(Map<String, dynamic> json) {
    return SavedChecklist(
      id: json['id'] ?? '',
      checkType: json['check_type'],
      keyChecklist: json['key_checklist'],
      valueChecklist: json['value_checklist'],
      photo: json['photo'],
      video: json['video'],
      existingPhotoUrl: json['existing_photo_url'],
      existingVideoUrl: json['existing_video_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'check_type': checkType,
      'key_checklist': keyChecklist,
      'value_checklist': valueChecklist,
      'photo': photo,
      'video': video,
      'existing_photo_url': existingPhotoUrl,
      'existing_video_url': existingVideoUrl,
    };
  }

  @override
  List<Object?> get props =>
      [id, checkType, keyChecklist, valueChecklist, photo, video, existingPhotoUrl, existingVideoUrl];
}

class SavedDescription extends Equatable {
  final int srNo;
  final String description;

  const SavedDescription({
    required this.srNo,
    required this.description,
  });

  factory SavedDescription.fromJson(Map<String, dynamic> json) {
    return SavedDescription(
      srNo: json['sr_no'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sr_no': srNo,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [srNo, description];
}
