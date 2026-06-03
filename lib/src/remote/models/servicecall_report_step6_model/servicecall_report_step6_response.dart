class ServiceCallStep6Response {
  final int status;
  final bool success;
  final String message;

  ServiceCallStep6Response({
    required this.status,
    required this.success,
    required this.message,
  });

  factory ServiceCallStep6Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep6Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
    };
  }
}
