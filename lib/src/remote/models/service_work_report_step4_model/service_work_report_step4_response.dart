import 'package:equatable/equatable.dart';

class ServiceWorkReportStep4Response extends Equatable {
  final int status;
  final bool success;
  final ServiceWorkReportStep4Data data;
  final String message;

  const ServiceWorkReportStep4Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ServiceWorkReportStep4Response.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep4Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ServiceWorkReportStep4Data.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data.toJson(),
      'message': message,
    };
  }

  @override
  List<Object?> get props => [status, success, data, message];
}

class ServiceWorkReportStep4Data extends Equatable {
  final String id;
  final String technicianRemarks;
  final String customerRemarks;
  final String technicianSignature;
  final String customerRepresentativeName;
  final String customerSignature;
  final List<String> savedWorkPhotos;
  final String technicianRepresentativeName;
  final String qrCodeUrl;
  final String qrCodeImage;

  const ServiceWorkReportStep4Data({
    required this.id,
    required this.technicianRemarks,
    required this.customerRemarks,
    required this.technicianSignature,
    required this.customerRepresentativeName,
    required this.customerSignature,
    required this.savedWorkPhotos,
    required this.technicianRepresentativeName,
    required this.qrCodeUrl,
    required this.qrCodeImage,
  });

  factory ServiceWorkReportStep4Data.fromJson(Map<String, dynamic> json) {
    return ServiceWorkReportStep4Data(
      id: json['id'] ?? '',
      technicianRemarks: json['technician_remarks'] ?? '',
      customerRemarks: json['customer_remarks'] ?? '',
      technicianSignature: json['technician_signature'] ?? '',
      customerRepresentativeName: json['customer_representative_name'] ?? '',
      customerSignature: json['customer_signature'] ?? '',
      savedWorkPhotos: List<String>.from(json['saved_work_photos'] ?? []),
      technicianRepresentativeName: json['technician_representative_name'] ?? '',
      qrCodeUrl: json['qr_code_url'] ?? '',
      qrCodeImage: json['qr_code_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'technician_remarks': technicianRemarks,
      'customer_remarks': customerRemarks,
      'technician_signature': technicianSignature,
      'customer_representative_name': customerRepresentativeName,
      'customer_signature': customerSignature,
      'saved_work_photos': savedWorkPhotos,
      'technician_representative_name': technicianRepresentativeName,
      'qr_code_url': qrCodeUrl,
      'qr_code_image': qrCodeImage,
    };
  }

  @override
  List<Object?> get props => [
    id,
    technicianRemarks,
    customerRemarks,
    technicianSignature,
    customerRepresentativeName,
    customerSignature,
    savedWorkPhotos,
    technicianRepresentativeName,
    qrCodeUrl,
    qrCodeImage,
  ];
}
