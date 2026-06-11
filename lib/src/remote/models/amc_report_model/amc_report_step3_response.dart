import 'package:equatable/equatable.dart';

class AmcReportStep3Response extends Equatable {
  final int status;
  final bool success;
  final AmcReportStep3Data data;
  final String message;

  const AmcReportStep3Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcReportStep3Response.fromJson(Map<String, dynamic> json) {
    return AmcReportStep3Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: AmcReportStep3Data.fromJson(json['data'] ?? {}),
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

class AmcReportStep3Data extends Equatable {
  final String id;
  final String technicianRemarks;
  final String customerRemarks;
  final String? technicianSignature;
  final String customerRepresentativeName;
  final String? customerSignature;
  final List<String> savedWorkPhotos;
  final String technicianRepresentativeName;
  final String? qrCodeUrl;
  final String? qrCodeImage;

  const AmcReportStep3Data({
    required this.id,
    required this.technicianRemarks,
    required this.customerRemarks,
    this.technicianSignature,
    required this.customerRepresentativeName,
    this.customerSignature,
    required this.savedWorkPhotos,
    required this.technicianRepresentativeName,
    this.qrCodeUrl,
    this.qrCodeImage,
  });

  factory AmcReportStep3Data.fromJson(Map<String, dynamic> json) {
    return AmcReportStep3Data(
      id: json['id']?.toString() ?? '',
      technicianRemarks: json['technician_remarks']?.toString() ?? '',
      customerRemarks: json['customer_remarks']?.toString() ?? '',
      technicianSignature: json['technician_signature']?.toString(),
      customerRepresentativeName: json['customer_representative_name']?.toString() ?? '',
      customerSignature: json['customer_signature']?.toString(),
      savedWorkPhotos: (json['saved_work_photos'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      technicianRepresentativeName: json['technician_representative_name']?.toString() ?? '',
      qrCodeUrl: json['qr_code_url']?.toString(),
      qrCodeImage: json['qr_code_image']?.toString(),
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
