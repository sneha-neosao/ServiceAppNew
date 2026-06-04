class AddCustomerResponse {
  final int status;
  final bool success;
  final CustomerData? data;
  final String message;

  AddCustomerResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory AddCustomerResponse.fromJson(Map<String, dynamic> json) {
    return AddCustomerResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null ? CustomerData.fromJson(json['data']) : null,
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
}

class CustomerData {
  final String id;
  final String name;
  final List<dynamic> sites;
  final String? createdByDealerUser;
  final String createdByTechnician;
  final String createdByTechnicianName;
  final String createdByTechnicianCode;
  final String createdByTechnicianPhone;

  CustomerData({
    required this.id,
    required this.name,
    required this.sites,
    this.createdByDealerUser,
    required this.createdByTechnician,
    required this.createdByTechnicianName,
    required this.createdByTechnicianCode,
    required this.createdByTechnicianPhone,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sites: json['sites'] ?? [],
      createdByDealerUser: json['created_by_dealer_user'],
      createdByTechnician: json['created_by_technician'] ?? '',
      createdByTechnicianName: json['created_by_technician_name'] ?? '',
      createdByTechnicianCode: json['created_by_technician_code'] ?? '',
      createdByTechnicianPhone: json['created_by_technician_phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sites': sites,
      'created_by_dealer_user': createdByDealerUser,
      'created_by_technician': createdByTechnician,
      'created_by_technician_name': createdByTechnicianName,
      'created_by_technician_code': createdByTechnicianCode,
      'created_by_technician_phone': createdByTechnicianPhone,
    };
  }
}
