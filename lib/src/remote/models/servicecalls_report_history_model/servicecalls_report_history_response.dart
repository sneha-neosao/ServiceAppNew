class ServiceCallReportResponse {
  final int status;
  final bool success;
  final ReportData? data;
  final String message;

  ServiceCallReportResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory ServiceCallReportResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCallReportResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null ? ReportData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class ReportData {
  final List<ServiceCallReport> results;
  final Pagination pagination;

  ReportData({required this.results, required this.pagination});

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => ServiceCallReport.fromJson(e))
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class ServiceCallReport {
  final String id;
  final String complaintId;
  final String complaintNumber;
  final String customerName;
  final String siteName;
  final String dealerName;
  final String customerRepresentativeName;
  final String technicianRepresentativeName;
  final String status;
  final String submittedAt;
  final bool feedbackSubmitted;
  final String qrCodeUrl;
  final String qrCodeImage;
  final String reportType;
  final String reportDetailId;

  ServiceCallReport({
    required this.id,
    required this.complaintId,
    required this.complaintNumber,
    required this.customerName,
    required this.siteName,
    required this.dealerName,
    required this.customerRepresentativeName,
    required this.technicianRepresentativeName,
    required this.status,
    required this.submittedAt,
    required this.feedbackSubmitted,
    required this.qrCodeUrl,
    required this.qrCodeImage,
    required this.reportType,
    required this.reportDetailId,
  });

  factory ServiceCallReport.fromJson(Map<String, dynamic> json) {
    final detail = json['report_detail'] as Map<String, dynamic>? ?? {};
    return ServiceCallReport(
      id: json['id'] ?? '',
      complaintId: json['complaint_id'] ?? '',
      complaintNumber: json['complaint_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteName: json['site_name'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      customerRepresentativeName:
          detail['customer_representative_name'] ??
          json['customer_representative_name'] ??
          '',
      technicianRepresentativeName:
          detail['technician_representative_name'] ??
          json['technician_representative_name'] ??
          '',
      status: json['status'] ?? '',
      submittedAt: detail['submitted_at'] ?? json['submitted_at'] ?? '',
      feedbackSubmitted:
          detail['feedback_submitted'] ?? json['feedback_submitted'] ?? false,
      qrCodeUrl: detail['qr_code_url'] ?? json['qr_code_url'] ?? '',
      qrCodeImage: detail['qr_code_image'] ?? json['qr_code_image'] ?? '',
      reportType: json['report_type'] ?? '',
      reportDetailId: detail['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complaint_id': complaintId,
      'complaint_number': complaintNumber,
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
      'report_type': reportType,
      'report_detail_id': reportDetailId,
    };
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      totalItems: json['total_items'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      'total_pages': totalPages,
      'total_items': totalItems,
    };
  }
}
