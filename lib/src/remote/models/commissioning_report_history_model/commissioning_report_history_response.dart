import 'package:equatable/equatable.dart';

class CommissioningReportHistoryResponse extends Equatable {
  final int status;
  final bool success;
  final CommissioningWorkListData data;
  final String message;

  const CommissioningReportHistoryResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportHistoryResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CommissioningReportHistoryResponse(
      status: json['status'],
      success: json['success'],
      data: CommissioningWorkListData.fromJson(json['data']),
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

class CommissioningWorkListData extends Equatable {
  final List<CommissioningWorkResult> results;
  final Pagination pagination;

  const CommissioningWorkListData({
    required this.results,
    required this.pagination,
  });

  factory CommissioningWorkListData.fromJson(Map<String, dynamic> json) {
    return CommissioningWorkListData(
      results: (json['results'] as List)
          .map((e) => CommissioningWorkResult.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  @override
  List<Object?> get props => [results, pagination];
}

class CommissioningWorkResult extends Equatable {
  final String id;
  final String commissioningWorkId;
  final String customerName;
  final String siteName;
  final String dealerName;
  final String warrantyStartDate;
  final String warrantyExpiryDate;
  final int warrantyPeriodYears;
  final String warrantyStatus;
  final String customerRepresentativeName;
  final String? technicianRepresentativeName;
  final String status;
  final String submittedAt;
  final bool feedbackSubmitted;
  final int lastCompletedStep;

  const CommissioningWorkResult({
    required this.id,
    required this.commissioningWorkId,
    required this.customerName,
    required this.siteName,
    required this.dealerName,
    required this.warrantyStartDate,
    required this.warrantyExpiryDate,
    required this.warrantyPeriodYears,
    required this.warrantyStatus,
    required this.customerRepresentativeName,
    this.technicianRepresentativeName,
    required this.status,
    required this.submittedAt,
    required this.feedbackSubmitted,
    required this.lastCompletedStep,
  });

  factory CommissioningWorkResult.fromJson(Map<String, dynamic> json) {
    return CommissioningWorkResult(
      id: json['id'],
      commissioningWorkId: json['commissioning_work_id'],
      customerName: json['customer_name'],
      siteName: json['site_name'],
      dealerName: json['dealer_name'],
      warrantyStartDate: json['warranty_start_date'],
      warrantyExpiryDate: json['warranty_expiry_date'],
      warrantyPeriodYears: json['warranty_period_years'],
      warrantyStatus: json['warranty_status'],
      customerRepresentativeName: json['customer_representative_name'],
      technicianRepresentativeName: json['technician_representative_name'],
      status: json['status'],
      submittedAt: json['submitted_at'],
      feedbackSubmitted: json['feedback_submitted'],
      lastCompletedStep: json['last_completed_step'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commissioning_work_id': commissioningWorkId,
      'customer_name': customerName,
      'site_name': siteName,
      'dealer_name': dealerName,
      'warranty_start_date': warrantyStartDate,
      'warranty_expiry_date': warrantyExpiryDate,
      'warranty_period_years': warrantyPeriodYears,
      'warranty_status': warrantyStatus,
      'customer_representative_name': customerRepresentativeName,
      'technician_representative_name': technicianRepresentativeName,
      'status': status,
      'submitted_at': submittedAt,
      'feedback_submitted': feedbackSubmitted,
      'last_completed_step': lastCompletedStep,
    };
  }

  @override
  List<Object?> get props => [
    id,
    commissioningWorkId,
    customerName,
    siteName,
    dealerName,
    warrantyStartDate,
    warrantyExpiryDate,
    warrantyPeriodYears,
    warrantyStatus,
    customerRepresentativeName,
    technicianRepresentativeName,
    status,
    submittedAt,
    feedbackSubmitted,
    lastCompletedStep,
  ];
}

class Pagination extends Equatable {
  final int page;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const Pagination({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
      totalItems: json['total_items'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      'total_pages': totalPages,
      'total_items': totalItems,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, totalPages, totalItems];
}
