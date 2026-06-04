import 'package:equatable/equatable.dart';

class CommissioningWorkDetailsResponse extends Equatable {
  final int status;
  final bool success;
  final CommissioningWorkDetailsData data;
  final String message;

  const CommissioningWorkDetailsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningWorkDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningWorkDetailsResponse(
      status: json['status'],
      success: json['success'],
      data: CommissioningWorkDetailsData.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data.toJson(),
    'message': message,
  };

  @override
  List<Object?> get props => [status, success, data, message];
}

class CommissioningWorkDetailsData extends Equatable {
  final String id;
  final String applicationOfEquipment;
  final Customer customer;
  final Site site;
  final List<AssignedTechnician> assignedTechnicians;
  final String? createdByDealerUser;
  final String createdByTechnician;

  const CommissioningWorkDetailsData({
    required this.id,
    required this.applicationOfEquipment,
    required this.customer,
    required this.site,
    required this.assignedTechnicians,
    this.createdByDealerUser,
    required this.createdByTechnician,
  });

  factory CommissioningWorkDetailsData.fromJson(Map<String, dynamic> json) {
    return CommissioningWorkDetailsData(
      id: json['id'],
      applicationOfEquipment: json['application_of_equipment'],
      customer: Customer.fromJson(json['customer']),
      site: Site.fromJson(json['site']),
      assignedTechnicians: (json['assigned_technicians'] as List)
          .map((e) => AssignedTechnician.fromJson(e))
          .toList(),
      createdByDealerUser: json['created_by_dealer_user'],
      createdByTechnician: json['created_by_technician'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'application_of_equipment': applicationOfEquipment,
    'customer': customer.toJson(),
    'site': site.toJson(),
    'assigned_technicians': assignedTechnicians.map((e) => e.toJson()).toList(),
    'created_by_dealer_user': createdByDealerUser,
    'created_by_technician': createdByTechnician,
  };

  @override
  List<Object?> get props => [
    id,
    applicationOfEquipment,
    customer,
    site,
    assignedTechnicians,
    createdByDealerUser,
    createdByTechnician,
  ];
}

class Customer extends Equatable {
  final String id;
  final String name;

  const Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class Site extends Equatable {
  final String id;
  final String name;

  const Site({required this.id, required this.name});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class AssignedTechnician extends Equatable {
  final String id;
  final String name;
  final String code;

  const AssignedTechnician({
    required this.id,
    required this.name,
    required this.code,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code};

  @override
  List<Object?> get props => [id, name, code];
}
