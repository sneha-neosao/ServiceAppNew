import 'package:service_app/src/remote/models/servicecall_report_step6_autofill_model/servicecall_report_step6_autofill_response.dart';

class ServiceCallStep6Response {
  final int status;
  final bool success;
  final String message;
  final ServiceCallStep6Data data;

  ServiceCallStep6Response({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceCallStep6Response.fromJson(Map<String, dynamic> json) {
    return ServiceCallStep6Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ServiceCallStep6Data.fromJson(json['data']) : const ServiceCallStep6Data.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}
