class AmcVisitCompleteResponse {
  final int? status;
  final bool? success;
  final AmcVisitCompleteData? data;
  final String? message;

  AmcVisitCompleteResponse({
    this.status,
    this.success,
    this.data,
    this.message,
  });

  factory AmcVisitCompleteResponse.fromJson(Map<String, dynamic> json) {
    return AmcVisitCompleteResponse(
      status: json['status'] as int?,
      success: json['success'] as bool?,
      data: json['data'] != null
          ? AmcVisitCompleteData.fromJson(json['data'])
          : null,
      message: json['message'] as String?,
    );
  }
}

class AmcVisitCompleteData {
  final String? visitId;
  final int? visitNumber;
  final String? status;
  final String? qrCodeUrl;
  final String? qrCodeImage;

  AmcVisitCompleteData({
    this.visitId,
    this.visitNumber,
    this.status,
    this.qrCodeUrl,
    this.qrCodeImage,
  });

  factory AmcVisitCompleteData.fromJson(Map<String, dynamic> json) {
    return AmcVisitCompleteData(
      visitId: json['visit_id'] as String?,
      visitNumber: json['visit_number'] as int?,
      status: json['status'] as String?,
      qrCodeUrl: json['qr_code_url'] as String?,
      qrCodeImage: json['qr_code_image'] as String?,
    );
  }
}
