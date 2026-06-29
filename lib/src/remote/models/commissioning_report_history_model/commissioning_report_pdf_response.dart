class CommissioningReportPdfResponse {
  final int status;
  final bool success;
  final PdfData? data;
  final String message;

  CommissioningReportPdfResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory CommissioningReportPdfResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningReportPdfResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null ? PdfData.fromJson(json['data']) : null,
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

class PdfData {
  final String pdfUrl;

  PdfData({required this.pdfUrl});

  factory PdfData.fromJson(Map<String, dynamic> json) {
    return PdfData(
      pdfUrl: json['pdf_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf_url': pdfUrl,
    };
  }
}
