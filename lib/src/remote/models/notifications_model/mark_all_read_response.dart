class MarkAllReadResponse {
  final int status;
  final bool success;
  final MarkAllReadData? data;
  final String? message;

  const MarkAllReadResponse({
    required this.status,
    required this.success,
    this.data,
    this.message,
  });

  factory MarkAllReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkAllReadResponse(
      status: json['status'] as int,
      success: json['success'] as bool,
      data: json['data'] != null
          ? MarkAllReadData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }
}

class MarkAllReadData {
  final int updatedCount;

  const MarkAllReadData({required this.updatedCount});

  factory MarkAllReadData.fromJson(Map<String, dynamic> json) {
    return MarkAllReadData(
      updatedCount: json['updated_count'] as int,
    );
  }
}
