class ServiceWorkReportStep2Response {
  final int status;
  final bool success;
  final ServiceWorkReportStep2Data data;
  final String message;

  ServiceWorkReportStep2Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceWorkReportStep2Response.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep2Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceWorkReportStep2Data.fromJson(json['data'] ?? {}),
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

class ServiceWorkReportStep2Data {
  final String id;
  final bool isTechnicalNa;
  final String technicalDetails;
  final List<ServiceWorkSavedDescription> savedDescriptions;
  final int lastCompletedStep;

  ServiceWorkReportStep2Data({
    required this.id,
    required this.isTechnicalNa,
    required this.technicalDetails,
    required this.savedDescriptions,
    required this.lastCompletedStep,
  });

  factory ServiceWorkReportStep2Data.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep2Data(
      id: json['id']?.toString() ?? '',
      isTechnicalNa: json['is_technical_na'] ?? false,
      technicalDetails: json['technical_details']?.toString() ?? '',
      savedDescriptions:
          (json['saved_descriptions'] as List<dynamic>?)
              ?.map(
                (e) => ServiceWorkSavedDescription.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_technical_na': isTechnicalNa,
      'technical_details': technicalDetails,
      'saved_descriptions': savedDescriptions.map((e) => e.toJson()).toList(),
      'last_completed_step': lastCompletedStep,
    };
  }
}

class ServiceWorkSavedDescription {
  final int srNo;
  final String description;

  ServiceWorkSavedDescription({required this.srNo, required this.description});

  factory ServiceWorkSavedDescription.fromJson(Map<String, dynamic> json) {
    return ServiceWorkSavedDescription(
      srNo: json['sr_no'] ?? 0,
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'sr_no': srNo, 'description': description};
  }
}
