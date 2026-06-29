class AmcVisitsListResponse {
  final int status;
  final bool success;
  final List<AmcVisitData> data;
  final String message;

  AmcVisitsListResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcVisitsListResponse.fromJson(Map<String, dynamic> json) {
    return AmcVisitsListResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => AmcVisitData.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class AmcVisitData {
  final String id;
  final String amcVisitId;
  final int visitNumber;
  final int totalVisits;
  final String customerName;
  final String siteName;
  final String dealerName;
  final String? customerRepresentativeName;
  final String? technicianRepresentativeName;
  final String status;
  final String? submittedAt;
  final bool feedbackSubmitted;
  final String? qrCodeUrl;
  final String? qrCodeImage;
  final String? fromDate;
  final String? toDate;
  final int stepNo;

  AmcVisitData({
    required this.id,
    required this.amcVisitId,
    required this.visitNumber,
    this.totalVisits = 0,
    required this.customerName,
    required this.siteName,
    required this.dealerName,
    this.customerRepresentativeName,
    this.technicianRepresentativeName,
    required this.status,
    this.submittedAt,
    required this.feedbackSubmitted,
    this.qrCodeUrl,
    this.qrCodeImage,
    this.fromDate,
    this.toDate,
    this.stepNo = 0,
  });

  factory AmcVisitData.fromJson(Map<String, dynamic> json) {
    return AmcVisitData(
      id: json['id'] ?? json['visit_id'] ?? '',
      amcVisitId: json['amc_visit_id'] ?? json['visit_id'] ?? '',
      visitNumber: json['visit_number'] ?? 0,
      totalVisits: json['total_visits'] ?? 0,
      customerName: json['customer_name'] ?? '',
      siteName: json['site_name'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      customerRepresentativeName: json['customer_representative_name'],
      technicianRepresentativeName: json['technician_representative_name'],
      status: json['status'] ?? json['visit_status'] ?? '',
      submittedAt: json['submitted_at'],
      feedbackSubmitted: json['feedback_submitted'] ?? false,
      qrCodeUrl: json['qr_code_url'],
      qrCodeImage: json['qr_code_image'],
      fromDate: json['visit_from_date'],
      toDate: json['visit_to_date'],
      stepNo: json['step_no'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amc_visit_id': amcVisitId,
      'visit_number': visitNumber,
      'total_visits': totalVisits,
      'customer_name': customerName,
      'site_name': siteName,
      'dealer_name': dealerName,
      'customer_representative_name': customerRepresentativeName,
      'technician_representative_name': technicianRepresentativeName,
      'status': status,
      'submitted_at': submittedAt,
      'feedback_submitted': feedbackSubmitted,
      'qr_code_url': qrCodeUrl,
      'qr_code_image': qrCodeImage,
      'from_date': fromDate,
      'to_date': toDate,
      'step_no': stepNo,
    };
  }
}
