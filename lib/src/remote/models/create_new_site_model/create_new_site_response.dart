class AddSiteResponse {
  final int status;
  final bool success;
  final CustomerData? data;
  final String message;

  AddSiteResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory AddSiteResponse.fromJson(Map<String, dynamic> json) {
    return AddSiteResponse(
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
  final List<Site> sites;
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
      sites:
          (json['sites'] as List<dynamic>?)
              ?.map((e) => Site.fromJson(e))
              .toList() ??
          [],
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
      'sites': sites.map((e) => e.toJson()).toList(),
      'created_by_dealer_user': createdByDealerUser,
      'created_by_technician': createdByTechnician,
      'created_by_technician_name': createdByTechnicianName,
      'created_by_technician_code': createdByTechnicianCode,
      'created_by_technician_phone': createdByTechnicianPhone,
    };
  }
}

class Site {
  final String id;
  final String name;
  final List<Contact> contacts;

  Site({required this.id, required this.name, required this.contacts});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => Contact.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contacts': contacts.map((e) => e.toJson()).toList(),
    };
  }
}

class Contact {
  // Placeholder for now since API returns []
  Contact();

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
