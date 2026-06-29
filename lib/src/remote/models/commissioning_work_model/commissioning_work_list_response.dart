class CommissioningWorkListResponse {
  final int status;
  final bool success;
  final String message;
  final List<CommissioningWork> data;

  CommissioningWorkListResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory CommissioningWorkListResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningWorkListResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data']['results'] != null)
          ? (json['data']['results'] as List<dynamic>)
                .map((e) => CommissioningWork.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CommissioningWork {
  final String id;
  final String applicationOfEquipment;
  final Customer customer;
  final Site site;
  final List<Technician> assignedTechnicians;
  final String? createdByDealerUser;
  final String? createdByTechnician;
  final int stepNo;
  final String? reportId;

  CommissioningWork({
    required this.id,
    required this.applicationOfEquipment,
    required this.customer,
    required this.site,
    required this.assignedTechnicians,
    this.createdByDealerUser,
    this.createdByTechnician,
    this.stepNo = 0,
    this.reportId,
  });

  factory CommissioningWork.fromJson(Map<String, dynamic> json) {
    return CommissioningWork(
      id: json['id'] ?? '',
      applicationOfEquipment: json['application_of_equipment'] ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}),
      site: Site.fromJson(json['site'] ?? {}),
      assignedTechnicians:
          (json['assigned_technicians'] as List<dynamic>?)
              ?.map((e) => Technician.fromJson(e))
              .toList() ??
          [],
      createdByDealerUser: json['created_by_dealer_user'],
      createdByTechnician: json['created_by_technician'],
      stepNo: json['step_no'] ?? 0,
      reportId: json['report_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application_of_equipment': applicationOfEquipment,
      'customer': customer.toJson(),
      'site': site.toJson(),
      'assigned_technicians': assignedTechnicians
          .map((e) => e.toJson())
          .toList(),
      'created_by_dealer_user': createdByDealerUser,
      'created_by_technician': createdByTechnician,
      'step_no': stepNo,
      'report_id': reportId,
    };
  }
}

class Customer {
  final String id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Site {
  final String id;
  final String name;

  Site({required this.id, required this.name});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Technician {
  final String id;
  final String name;
  final String code;

  Technician({required this.id, required this.name, required this.code});

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }
}
