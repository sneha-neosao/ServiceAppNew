class CommissioningReportStep2AutoFillResponse {
  final int status;
  final bool success;
  final CommissioningData data;
  final String message;

  CommissioningReportStep2AutoFillResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportStep2AutoFillResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningReportStep2AutoFillResponse(
      status: json['status'],
      success: json['success'],
      data: CommissioningData.fromJson(json['data']),
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
}

class CommissioningData {
  final String id;
  final String commissioningWorkId;
  final String dealerName;
  final String customerName;
  final String siteName;
  final String applicationOfEquipment;
  final List<Technician> assignedTechnicians;
  final int lastCompletedStep;

  CommissioningData({
    required this.id,
    required this.commissioningWorkId,
    required this.dealerName,
    required this.customerName,
    required this.siteName,
    required this.applicationOfEquipment,
    required this.assignedTechnicians,
    required this.lastCompletedStep,
  });

  factory CommissioningData.fromJson(Map<String, dynamic> json) {
    return CommissioningData(
      id: json['id'],
      commissioningWorkId: json['commissioning_work_id'],
      dealerName: json['dealer_name'],
      customerName: json['customer_name'],
      siteName: json['site_name'],
      applicationOfEquipment: json['application_of_equipment'],
      assignedTechnicians: (json['assigned_technicians'] as List)
          .map((e) => Technician.fromJson(e))
          .toList(),
      lastCompletedStep: json['last_completed_step'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commissioning_work_id': commissioningWorkId,
      'dealer_name': dealerName,
      'customer_name': customerName,
      'site_name': siteName,
      'application_of_equipment': applicationOfEquipment,
      'assigned_technicians':
      assignedTechnicians.map((e) => e.toJson()).toList(),
      'last_completed_step': lastCompletedStep,
    };
  }
}

class Technician {
  final String id;
  final String name;

  Technician({
    required this.id,
    required this.name,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
