class ServiceCallStep3Response {
  final int status;
  final bool success;
  final ServiceCallStep3Data data;
  final String message;

  ServiceCallStep3Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceCallStep3Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep3Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceCallStep3Data.fromJson(json['data'] ?? {}),
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

class ServiceCallStep3Data {
  final String id;
  final bool isTechnicalNa;
  final Map<String, dynamic> technicalDetails;
  final int lastCompletedStep;

  ServiceCallStep3Data({
    required this.id,
    required this.isTechnicalNa,
    required this.technicalDetails,
    required this.lastCompletedStep,
  });

  factory ServiceCallStep3Data.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep3Data(
      id: json['id'] ?? '',
      isTechnicalNa: json['is_technical_na'] ?? false,
      technicalDetails: json['technical_details'] ?? {},
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_technical_na': isTechnicalNa,
      'technical_details': technicalDetails,
      'last_completed_step': lastCompletedStep,
    };
  }
}
