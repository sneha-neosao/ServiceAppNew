class DeleteAmcReportResponse {
  final int? status;
  final bool? success;
  final dynamic data;
  final String? message;

  DeleteAmcReportResponse({this.status, this.success, this.data, this.message});

  factory DeleteAmcReportResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAmcReportResponse(
      status: json['status'] as int?,
      success: json['success'] as bool?,
      data: json['data'],
      message: json['message'] as String?,
    );
  }
}
