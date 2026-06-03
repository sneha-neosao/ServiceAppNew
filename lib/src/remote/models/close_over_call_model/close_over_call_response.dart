class CloseOverCallResponse {
  final int status;
  final bool success;
  final ComplaintData data;
  final String message;

  CloseOverCallResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CloseOverCallResponse.fromJson(Map<String, dynamic> json) {
    return CloseOverCallResponse(
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
  final String serviceStatus;
  final String serviceCallDetails;
  final ClosedBy closedBy;

  ComplaintData({
    required this.complaintId,
    required this.complaintNumber,
    required this.status,
    required this.serviceStatus,
    required this.serviceCallDetails,
    required this.closedBy,
  });

  factory ComplaintData.fromJson(Map<String, dynamic> json) {
    return ComplaintData(
      complaintId: json['complaint_id'] ?? '',
      complaintNumber: json['complaint_number'] ?? '',
      status: json['status'] ?? '',
      serviceStatus: json['service_status'] ?? '',
      serviceCallDetails: json['service_call_details'] ?? '',
      closedBy: ClosedBy.fromJson(json['closed_by'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaint_id': complaintId,
      'complaint_number': complaintNumber,
      'status': status,
      'service_status': serviceStatus,
      'service_call_details': serviceCallDetails,
      'closed_by': closedBy.toJson(),
    };
  }
}

class ClosedBy {
  final String technicianId;
  final String technicianName;
  final String technicianCode;

  ClosedBy({
    required this.technicianId,
    required this.technicianName,
    required this.technicianCode,
  });

  factory ClosedBy.fromJson(Map<String, dynamic> json) {
    return ClosedBy(
      technicianId: json['technician_id'] ?? '',
      technicianName: json['technician_name'] ?? '',
      technicianCode: json['technician_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technician_id': technicianId,
      'technician_name': technicianName,
      'technician_code': technicianCode,
    };
  }
}
