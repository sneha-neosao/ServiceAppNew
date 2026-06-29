class ServiceWorkReportStep1Response {
  final int status;
  final bool success;
  final ServiceWorkReportStep1Data data;
  final String message;

  ServiceWorkReportStep1Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceWorkReportStep1Response.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep1Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceWorkReportStep1Data.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class ServiceWorkReportStep1Data {
  final String id;
  final String complaintId;
  final String memberPresentsCustomerSide;
  final String agenda;
  final String dealerName;
  final String customerName;
  final String? customerId;
  final String siteName;
  final String? siteId;
  final List<AssignedTechnician> assignedTechnicians;
  final int lastCompletedStep;

  ServiceWorkReportStep1Data({
    required this.id,
    required this.complaintId,
    required this.memberPresentsCustomerSide,
    required this.agenda,
    required this.dealerName,
    required this.customerName,
    this.customerId,
    required this.siteName,
    this.siteId,
    required this.assignedTechnicians,
    required this.lastCompletedStep,
  });

  factory ServiceWorkReportStep1Data.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep1Data(
      id: json['id']?.toString() ?? '',
      complaintId: json['complaint_id']?.toString() ?? '',
      memberPresentsCustomerSide: json['member_presents_customer_side'] is List
          ? (json['member_presents_customer_side'] as List).join(", ")
          : (json['member_presents_customer_side']?.toString() ?? ''),
      agenda: json['agenda']?.toString() ?? '',
      dealerName: json['dealer_name']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerId: json['customer_id']?.toString(),
      siteName: json['site_name']?.toString() ?? '',
      siteId: json['site_id']?.toString(),
      assignedTechnicians:
          (json['assigned_technicians'] as List<dynamic>?)
              ?.map(
                (e) => AssignedTechnician.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }
}

class AssignedTechnician {
  final String id;
  final String name;

  AssignedTechnician({required this.id, required this.name});

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
