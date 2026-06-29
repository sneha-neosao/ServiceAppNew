class AmcReportPdfResponse {
  final int status;
  final bool success;
  final AmcReportPdfData? data;
  final String message;

  AmcReportPdfResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory AmcReportPdfResponse.fromJson(Map<String, dynamic> json) {
    return AmcReportPdfResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null ? AmcReportPdfData.fromJson(json['data']) : null,
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

class AmcReportPdfData {
  final String pdfUrl;

  AmcReportPdfData({required this.pdfUrl});

  factory AmcReportPdfData.fromJson(Map<String, dynamic> json) {
    return AmcReportPdfData(
      pdfUrl: json['pdf_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf_url': pdfUrl,
    };
  }
}
