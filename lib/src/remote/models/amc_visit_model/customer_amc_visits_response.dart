import 'package:equatable/equatable.dart';

class CustomerAmcVisitsResponse extends Equatable {
  final int status;
  final bool success;
  final CustomerAmcVisitsData? data;
  final String message;

  const CustomerAmcVisitsResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory CustomerAmcVisitsResponse.fromJson(Map<String, dynamic> json) {
    return CustomerAmcVisitsResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null ? CustomerAmcVisitsData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }

  @override
  List<Object?> get props => [status, success, data, message];
}

class CustomerAmcVisitsData extends Equatable {
  final List<CustomerAmcVisitItem> results;
  final CustomerAmcPagination? pagination;

  const CustomerAmcVisitsData({
    required this.results,
    this.pagination,
  });

  factory CustomerAmcVisitsData.fromJson(Map<String, dynamic> json) {
    return CustomerAmcVisitsData(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => CustomerAmcVisitItem.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? CustomerAmcPagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  @override
  List<Object?> get props => [results, pagination];
}

class CustomerAmcVisitItem extends Equatable {
  final String visitId;
  final int visitNumber;
  final String visitFromDate;
  final String visitToDate;
  final String visitStatus;
  final String amcDateId;
  final String contractStart;
  final String contractEnd;
  final String contractStatus;
  final int amcDuration;
  final int visitsPerYear;
  final int totalVisits;
  final int completedVisits;
  final String amcId;
  final String customerId;
  final String customerName;
  final String siteId;
  final String siteName;
  final bool feedbackSubmitted;
  final String? qrCodeUrl;
  final String? qrCodeImage;
  final List<CustomerAmcVisitReport> reports;

  const CustomerAmcVisitItem({
    required this.visitId,
    required this.visitNumber,
    required this.visitFromDate,
    required this.visitToDate,
    required this.visitStatus,
    required this.amcDateId,
    required this.contractStart,
    required this.contractEnd,
    required this.contractStatus,
    required this.amcDuration,
    required this.visitsPerYear,
    required this.totalVisits,
    required this.completedVisits,
    required this.amcId,
    required this.customerId,
    required this.customerName,
    required this.siteId,
    required this.siteName,
    required this.feedbackSubmitted,
    this.qrCodeUrl,
    this.qrCodeImage,
    required this.reports,
  });

  factory CustomerAmcVisitItem.fromJson(Map<String, dynamic> json) {
    return CustomerAmcVisitItem(
      visitId: json['visit_id'] ?? '',
      visitNumber: json['visit_number'] ?? 0,
      visitFromDate: json['visit_from_date'] ?? '',
      visitToDate: json['visit_to_date'] ?? '',
      visitStatus: json['visit_status'] ?? '',
      amcDateId: json['amc_date_id'] ?? '',
      contractStart: json['contract_start'] ?? '',
      contractEnd: json['contract_end'] ?? '',
      contractStatus: json['contract_status'] ?? '',
      amcDuration: json['amc_duration'] ?? 0,
      visitsPerYear: json['visits_per_year'] ?? 0,
      totalVisits: json['total_visits'] ?? 0,
      completedVisits: json['completed_visits'] ?? 0,
      amcId: json['amc_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteId: json['site_id'] ?? '',
      siteName: json['site_name'] ?? '',
      feedbackSubmitted: json['feedback_submitted'] ?? false,
      qrCodeUrl: json['qr_code_url'],
      qrCodeImage: json['qr_code_image'],
      reports: (json['reports'] as List<dynamic>?)
              ?.map((e) => CustomerAmcVisitReport.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_id': visitId,
      'visit_number': visitNumber,
      'visit_from_date': visitFromDate,
      'visit_to_date': visitToDate,
      'visit_status': visitStatus,
      'amc_date_id': amcDateId,
      'contract_start': contractStart,
      'contract_end': contractEnd,
      'contract_status': contractStatus,
      'amc_duration': amcDuration,
      'visits_per_year': visitsPerYear,
      'total_visits': totalVisits,
      'completed_visits': completedVisits,
      'amc_id': amcId,
      'customer_id': customerId,
      'customer_name': customerName,
      'site_id': siteId,
      'site_name': siteName,
      'feedback_submitted': feedbackSubmitted,
      'qr_code_url': qrCodeUrl,
      'qr_code_image': qrCodeImage,
      'reports': reports.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        visitId,
        visitNumber,
        visitFromDate,
        visitToDate,
        visitStatus,
        amcDateId,
        contractStart,
        contractEnd,
        contractStatus,
        amcDuration,
        visitsPerYear,
        totalVisits,
        completedVisits,
        amcId,
        customerId,
        customerName,
        siteId,
        siteName,
        feedbackSubmitted,
        qrCodeUrl,
        qrCodeImage,
        reports,
      ];
}

class CustomerAmcVisitReport extends Equatable {
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

  const CustomerAmcVisitReport({
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

  factory CustomerAmcVisitReport.fromJson(Map<String, dynamic> json) {
    return CustomerAmcVisitReport(
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

class CustomerAmcPagination extends Equatable {
  final int page;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const CustomerAmcPagination({
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory CustomerAmcPagination.fromJson(Map<String, dynamic> json) {
    return CustomerAmcPagination(
      page: json['page'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      totalItems: json['total_items'] ?? 0,
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
