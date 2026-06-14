class DeleteServiceWorkReportResponse {
  final int status;
  final bool success;
  final String message;

  DeleteServiceWorkReportResponse({
    required this.status,
    required this.success,
    required this.message,
  });

  factory DeleteServiceWorkReportResponse.fromJson(Map<String, dynamic> json) {
    return DeleteServiceWorkReportResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
