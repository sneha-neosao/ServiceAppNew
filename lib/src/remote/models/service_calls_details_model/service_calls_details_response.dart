class ServiceCallDetailsResponse {
  final int status;
  final bool success;
  final ServiceCallDetails data;
  final String message;

  ServiceCallDetailsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceCallDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCallDetailsResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceCallDetails.fromJson(json['data'] ?? {}),
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

class ServiceCallDetails {
  final String id;
  final String complaintNumber;
  final String status;
  final String? serviceStatus;
  final String? serviceCallDetails;
  final String name;
  final String contactNumber;
  final String equipmentModelName;
  final String complaintDetails;
  final String customerId;
  final String customerName;
  final String siteId;
  final String siteName;
  final String dealerId;
  final String dealerName;
  final List<dynamic> assignedTechnicians;
  final List<dynamic> attachments;
  final List<dynamic> manualReportMedia;
  final bool isReportSubmitted;
  final String? reportId;
  final String? reportStatus;
  final String createdAt;

  ServiceCallDetails({
    required this.id,
    required this.complaintNumber,
    required this.status,
    this.serviceStatus,
    this.serviceCallDetails,
    required this.name,
    required this.contactNumber,
    required this.equipmentModelName,
    required this.complaintDetails,
    required this.customerId,
    required this.customerName,
    required this.siteId,
    required this.siteName,
    required this.dealerId,
    required this.dealerName,
    required this.assignedTechnicians,
    required this.attachments,
    required this.manualReportMedia,
    required this.isReportSubmitted,
    this.reportId,
    this.reportStatus,
    required this.createdAt,
  });

  factory ServiceCallDetails.fromJson(Map<String, dynamic> json) {
    return ServiceCallDetails(
      id: json['id'] ?? '',
      complaintNumber: json['complaint_number'] ?? '',
      status: json['status'] ?? '',
      serviceStatus: json['service_status'],
      serviceCallDetails: json['service_call_details'],
      name: json['name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      equipmentModelName: json['equipment_model_name'] ?? '',
      complaintDetails: json['complaint_details'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteId: json['site_id'] ?? '',
      siteName: json['site_name'] ?? '',
      dealerId: json['dealer_id']?.toString() ?? '',
      dealerName: json['dealer_name'] ?? '',
      assignedTechnicians: json['assigned_technicians'] ?? [],
      attachments: json['attachments'] ?? [],
      manualReportMedia: json['manual_report_media'] ?? [],
      isReportSubmitted: json['is_report_submitted'] ?? false,
      reportId: json['report_id'],
      reportStatus: json['report_status'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complaint_number': complaintNumber,
      'status': status,
      'service_status': serviceStatus,
      'service_call_details': serviceCallDetails,
      'name': name,
      'contact_number': contactNumber,
      'equipment_model_name': equipmentModelName,
      'complaint_details': complaintDetails,
      'customer_id': customerId,
      'customer_name': customerName,
      'site_id': siteId,
      'site_name': siteName,
      'dealer_id': dealerId,
      'dealer_name': dealerName,
      'assigned_technicians': assignedTechnicians,
      'attachments': attachments,
      'manual_report_media': manualReportMedia,
      'is_report_submitted': isReportSubmitted,
      'report_id': reportId,
      'report_status': reportStatus,
      'created_at': createdAt,
    };
  }
}
