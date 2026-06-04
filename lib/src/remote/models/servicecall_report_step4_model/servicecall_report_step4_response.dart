class ServiceCallStep4Response {
  final int status;
  final bool success;
  final ServiceCallStep4Data data;
  final String message;

  ServiceCallStep4Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceCallStep4Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep4Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceCallStep4Data.fromJson(json['data'] ?? {}),
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

class ServiceCallStep4Data {
  final String id;
  final List<SavedDescription> savedDescriptions;
  final int lastCompletedStep;

  ServiceCallStep4Data({
    required this.id,
    required this.savedDescriptions,
    required this.lastCompletedStep,
  });

  factory ServiceCallStep4Data.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep4Data(
      id: json['id'] ?? '',
      savedDescriptions:
          (json['saved_descriptions'] as List<dynamic>?)
              ?.map((e) => SavedDescription.fromJson(e))
              .toList() ??
          [],
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saved_descriptions': savedDescriptions.map((e) => e.toJson()).toList(),
      'last_completed_step': lastCompletedStep,
    };
  }
}

class SavedDescription {
  final int srNo;
  final String description;

  SavedDescription({required this.srNo, required this.description});

  factory SavedDescription.fromJson(Map<String, dynamic> json) {
    return SavedDescription(
      srNo: json['sr_no'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'sr_no': srNo, 'description': description};
  }
}
