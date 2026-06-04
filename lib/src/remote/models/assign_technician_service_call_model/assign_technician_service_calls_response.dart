class AssignTechnicianServiceCallsResponse {
  final int status;
  final bool success;
  final ComplaintData data;
  final String message;

  AssignTechnicianServiceCallsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AssignTechnicianServiceCallsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignTechnicianServiceCallsResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ComplaintData.fromJson(json['data'] ?? {}),
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

class ComplaintData {
  final String complaintId;
  final String complaintNumber;
  final String status;
  final List<AssignedTechnician> assignedTechnicians;

  ComplaintData({
    required this.complaintId,
    required this.complaintNumber,
    required this.status,
    required this.assignedTechnicians,
  });

  factory ComplaintData.fromJson(Map<String, dynamic> json) {
    return ComplaintData(
      complaintId: json['complaint_id'] ?? '',
      complaintNumber: json['complaint_number'] ?? '',
      status: json['status'] ?? '',
      assignedTechnicians:
          (json['assigned_technicians'] as List<dynamic>?)
              ?.map((e) => AssignedTechnician.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaint_id': complaintId,
      'complaint_number': complaintNumber,
      'status': status,
      'assigned_technicians': assignedTechnicians
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class AssignedTechnician {
  final String id;
  final String name;
  final String code;
  final String assignedAt;

  AssignedTechnician({
    required this.id,
    required this.name,
    required this.code,
    required this.assignedAt,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      assignedAt: json['assigned_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'assigned_at': assignedAt};
  }
}
