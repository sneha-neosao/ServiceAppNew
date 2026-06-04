import 'package:equatable/equatable.dart';

class CommissioningReportStep6AutoFillResponse extends Equatable {
  final int status;
  final bool success;
  final CommissioningStep6Data data;
  final String message;

  const CommissioningReportStep6AutoFillResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportStep6AutoFillResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CommissioningReportStep6AutoFillResponse(
      status: json['status'],
      success: json['success'],
      data: CommissioningStep6Data.fromJson(json['data']),
      message: json['message'],
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

class CommissioningStep6Data extends Equatable {
  final String id;
  final String technicianRemarks;
  final String customerRemarks;
  final String technicianSignature;
  final String customerRepresentativeName;
  final String customerSignature;
  final List<String> savedWorkPhotos;
  final String technicianRepresentativeName;
  final int lastCompletedStep;
  final String qrCodeUrl;
  final String qrCodeImage;

  const CommissioningStep6Data({
    required this.id,
    required this.technicianRemarks,
    required this.customerRemarks,
    required this.technicianSignature,
    required this.customerRepresentativeName,
    required this.customerSignature,
    required this.savedWorkPhotos,
    required this.technicianRepresentativeName,
    required this.lastCompletedStep,
    required this.qrCodeUrl,
    required this.qrCodeImage,
  });

  factory CommissioningStep6Data.fromJson(Map<String, dynamic> json) {
    return CommissioningStep6Data(
      id: json['id'] ?? '',
      technicianRemarks: json['technician_remarks'] ?? '',
      customerRemarks: json['customer_remarks'] ?? '',
      technicianSignature: json['technician_signature'] ?? '',
      customerRepresentativeName: json['customer_representative_name'] ?? '',
      customerSignature: json['customer_signature'] ?? '',
      savedWorkPhotos: List<String>.from(json['saved_work_photos'] ?? []),
      technicianRepresentativeName:
          json['technician_representative_name'] ?? '',
      lastCompletedStep: json['last_completed_step'] ?? 5,
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
      'last_completed_step': lastCompletedStep,
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
    lastCompletedStep,
    qrCodeUrl,
    qrCodeImage,
  ];
}
