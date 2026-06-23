import 'package:equatable/equatable.dart';

class AssignedServiceCallsResponse extends Equatable {
  final int status;
  final bool success;
  final AssignedServiceCallsData data;
  final String message;

  const AssignedServiceCallsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AssignedServiceCallsResponse.fromJson(Map<String, dynamic> json) {
    return AssignedServiceCallsResponse(
      status: json['status'],
      success: json['success'],
      data: AssignedServiceCallsData.fromJson(json['data']),
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

class AssignedServiceCallsData extends Equatable {
  final List<ServiceCallResult> results;
  final Pagination pagination;

  const AssignedServiceCallsData({
    required this.results,
    required this.pagination,
  });

  factory AssignedServiceCallsData.fromJson(Map<String, dynamic> json) {
    return AssignedServiceCallsData(
      results: (json['results'] as List)
          .map((e) => ServiceCallResult.fromJson(e))
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

class ServiceCallResult extends Equatable {
  final String id;
  final String complaintNumber;
  final String status;
  final String? serviceStatus;
  final String? serviceCallDetails;
  final String name;
  final String contactNumber;
  final String equipmentModelName;
  final String complaintDetails;
  final String customerName;
  final String siteName;
  final String dealerName;
  final String customerId;
  final String siteId;
  final List<AssignedTechnician> assignedTechnicians;
  final String createdAt;
  final String? lastServiceDate;
  final int? step_no;

  const ServiceCallResult({
    required this.id,
    required this.complaintNumber,
    required this.status,
    this.serviceStatus,
    this.serviceCallDetails,
    required this.name,
    required this.contactNumber,
    required this.equipmentModelName,
    required this.complaintDetails,
    required this.customerName,
    required this.siteName,
    required this.dealerName,
    required this.customerId,
    required this.siteId,
    required this.assignedTechnicians,
    required this.createdAt,
    this.lastServiceDate,
    this.step_no
  });

  factory ServiceCallResult.fromJson(Map<String, dynamic> json) {
    return ServiceCallResult(
      id: json['id'] ?? '',
      complaintNumber: json['complaint_number'] ?? '',
      status: json['status'] ?? '',
      serviceStatus: json['service_status'],
      serviceCallDetails: json['service_call_details'],
      name: json['name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      equipmentModelName: json['equipment_model_name'] ?? '',
      complaintDetails: json['complaint_details'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteName: json['site_name'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      customerId: json['customer_id'] ?? '',
      siteId: json['site_id'] ?? '',
      assignedTechnicians:
          (json['assigned_technicians'] as List?)
              ?.map((e) => AssignedTechnician.fromJson(e))
              .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      lastServiceDate: json['last_service_date'],
      step_no: json["step_no"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complaint_number': complaintNumber,
      'status': status,
      'service_status': serviceStatus,
      'service_call_details': serviceCallDetails,
      'name': name,
      'contact_number': contactNumber,
      'equipment_model_name': equipmentModelName,
      'complaint_details': complaintDetails,
      'customer_name': customerName,
      'site_name': siteName,
      'dealer_name': dealerName,
      'customer_id': customerId,
      'site_id': siteId,
      'assigned_technicians': assignedTechnicians
          .map((e) => e.toJson())
          .toList(),
      'created_at': createdAt,
      'last_service_date': lastServiceDate,
      'step_no': step_no
    };
  }

  @override
  List<Object?> get props => [
    id,
    complaintNumber,
    status,
    serviceStatus,
    serviceCallDetails,
    name,
    contactNumber,
    equipmentModelName,
    complaintDetails,
    customerName,
    siteName,
    dealerName,
    customerId,
    siteId,
    assignedTechnicians,
    createdAt,
    lastServiceDate,
    step_no
  ];
}

class AssignedTechnician extends Equatable {
  final String id;
  final String name;
  final String code;
  final String assignedAt;

  const AssignedTechnician({
    required this.id,
    required this.name,
    required this.code,
    required this.assignedAt,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      assignedAt: json['assigned_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'assigned_at': assignedAt};
  }

  @override
  List<Object?> get props => [id, name, code, assignedAt];
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
