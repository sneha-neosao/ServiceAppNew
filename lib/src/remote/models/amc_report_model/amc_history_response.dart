import 'package:equatable/equatable.dart';

class AmcHistoryResponse extends Equatable {
  final int status;
  final bool success;
  final List<AmcHistoryData> data;
  final String message;

  const AmcHistoryResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AmcHistoryResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AmcHistoryData.fromJson(e))
          .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }

  @override
  List<Object?> get props => [status, success, data, message];
}

class AmcHistoryData extends Equatable {
  final String id;
  final String amcVisitId;
  final int visitNumber;
  final String customerId;
  final String customerName;
  final String siteName;
  final String dealerName;
  final String customerRepresentativeName;
  final String technicianRepresentativeName;
  final String status;
  final String submittedAt;
  final int stepNo;
  final int totalVisits;
  final int completedVisits;

  const AmcHistoryData({
    required this.id,
    required this.amcVisitId,
    required this.visitNumber,
    required this.customerId,
    required this.customerName,
    required this.siteName,
    required this.dealerName,
    required this.customerRepresentativeName,
    required this.technicianRepresentativeName,
    required this.status,
    required this.submittedAt,
    required this.stepNo,
    required this.totalVisits,
    required this.completedVisits,
  });

  factory AmcHistoryData.fromJson(Map<String, dynamic> json) {
    return AmcHistoryData(
      id: json['id'] ?? '',
      amcVisitId: json['amc_visit_id'] ?? '',
      visitNumber: json['visit_number'] ?? 0,
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteName: json['site_name'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      customerRepresentativeName: json['customer_representative_name'] ?? '',
      technicianRepresentativeName: json['technician_representative_name'] ?? '',
      status: json['status'] ?? '',
      submittedAt: json['submitted_at'] ?? '',
      stepNo: json['step_no'] ?? 0,
      totalVisits: json['total_visits'] ?? 0,
      completedVisits: json['completed_visits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amc_visit_id': amcVisitId,
      'visit_number': visitNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'site_name': siteName,
      'dealer_name': dealerName,
      'customer_representative_name': customerRepresentativeName,
      'technician_representative_name': technicianRepresentativeName,
      'status': status,
      'submitted_at': submittedAt,
      'step_no': stepNo,
      'total_visits': totalVisits,
      'completed_visits': completedVisits,
    };
  }

  @override
  List<Object?> get props => [
    id,
    amcVisitId,
    visitNumber,
    customerId,
    customerName,
    siteName,
    dealerName,
    customerRepresentativeName,
    technicianRepresentativeName,
    status,
    submittedAt,
    stepNo,
    totalVisits,
    completedVisits,
  ];
}
