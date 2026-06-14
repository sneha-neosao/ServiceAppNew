class ServiceCallStep2Response {
  final int status;
  final bool success;
  final ServiceCallStep2Data data;
  final String message;

  ServiceCallStep2Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceCallStep2Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep2Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceCallStep2Data.fromJson(json['data'] ?? {}),
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

class ServiceCallStep2Data {
  final String id;
  final String memberPresentsCustomerSide;
  final String agenda;
  final int lastCompletedStep;

  ServiceCallStep2Data({
    required this.id,
    required this.memberPresentsCustomerSide,
    required this.agenda,
    required this.lastCompletedStep,
  });

  factory ServiceCallStep2Data.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep2Data(
      id: json['id'] ?? '',
      memberPresentsCustomerSide: json['member_presents_customer_side'] is List
          ? (json['member_presents_customer_side'] as List).join(", ")
          : (json['member_presents_customer_side']?.toString() ?? ''),
      agenda: json['agenda'] ?? '',
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_presents_customer_side': memberPresentsCustomerSide,
      'agenda': agenda,
      'last_completed_step': lastCompletedStep,
    };
  }
}
