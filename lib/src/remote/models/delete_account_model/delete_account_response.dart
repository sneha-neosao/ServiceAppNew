class DeleteAccountResponse {
  final int status;
  final bool success;
  final dynamic data;
  final String message;

  DeleteAccountResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data,
      'message': message,
    };
  }
}
