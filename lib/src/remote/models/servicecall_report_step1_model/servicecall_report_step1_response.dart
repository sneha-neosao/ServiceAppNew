class ServiceCallStep1Response {
  final int status;
  final bool success;
  final ServiceCallData data;
  final String message;

  ServiceCallStep1Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceCallStep1Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep1Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceCallData.fromJson(json['data'] ?? {}),
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

class ServiceCallData {
  final String id;
  final String dealerName;
  final String customerName;
  final String siteName;
  final String complaintNumber;
  final List<AssignedTechnician> assignedTechnicians;
  final int lastCompletedStep;

  ServiceCallData({
    required this.id,
    required this.dealerName,
    required this.customerName,
    required this.siteName,
    required this.complaintNumber,
    required this.assignedTechnicians,
    required this.lastCompletedStep,
  });

  factory ServiceCallData.fromJson(Map<String, dynamic> json) {
    return ServiceCallData(
      id: json['id'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteName: json['site_name'] ?? '',
      complaintNumber: json['complaint_number'] ?? '',
      assignedTechnicians:
          (json['assigned_technicians'] as List<dynamic>?)
              ?.map((e) => AssignedTechnician.fromJson(e))
              .toList() ??
          [],
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealer_name': dealerName,
      'customer_name': customerName,
      'site_name': siteName,
      'complaint_number': complaintNumber,
      'assigned_technicians': assignedTechnicians
          .map((e) => e.toJson())
          .toList(),
      'last_completed_step': lastCompletedStep,
    };
  }
}

class AssignedTechnician {
  final String id;
  final String name;

  AssignedTechnician({required this.id, required this.name});

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
