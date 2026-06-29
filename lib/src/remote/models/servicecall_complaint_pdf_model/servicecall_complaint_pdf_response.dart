class ServiceCallComplaintPdfResponse {
  final int status;
  final bool success;
  final ServiceCallComplaintPdfData? data;
  final String message;

  ServiceCallComplaintPdfResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory ServiceCallComplaintPdfResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCallComplaintPdfResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ServiceCallComplaintPdfData.fromJson(json['data'])
          : null,
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

class ServiceCallComplaintPdfData {
  final String pdfUrl;

  ServiceCallComplaintPdfData({required this.pdfUrl});

  factory ServiceCallComplaintPdfData.fromJson(Map<String, dynamic> json) {
    return ServiceCallComplaintPdfData(pdfUrl: json['pdf_url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'pdf_url': pdfUrl};
  }
}
