class CommissioningReportStep4AutoFillResponse {
  final int status;
  final bool success;
  final CommissioningData data;
  final String message;

  CommissioningReportStep4AutoFillResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportStep4AutoFillResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CommissioningReportStep4AutoFillResponse(
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
  final List<SavedDescription> savedDescriptions;
  final int lastCompletedStep;

  CommissioningData({
    required this.id,
    required this.commissioningWorkId,
    required this.dealerName,
    required this.customerName,
    required this.siteName,
    required this.applicationOfEquipment,
    required this.assignedTechnicians,
    required this.savedDescriptions,
    required this.lastCompletedStep,
  });

  factory CommissioningData.fromJson(Map<String, dynamic> json) {
    return CommissioningData(
      id: json['id'] ?? '',
      commissioningWorkId: json['commissioning_work_id'] ?? '',
      dealerName: json['dealer_name'] ?? '',
      customerName: json['customer_name'] ?? '',
      siteName: json['site_name'] ?? '',
      applicationOfEquipment: json['application_of_equipment'] ?? '',
      assignedTechnicians:
          (json['assigned_technicians'] as List?)
              ?.map((e) => Technician.fromJson(e))
              .toList() ??
          [],
      savedDescriptions:
          (json['saved_descriptions'] as List?)
              ?.map((e) => SavedDescription.fromJson(e))
              .toList() ??
          [],
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
      'assigned_technicians': assignedTechnicians
          .map((e) => e.toJson())
          .toList(),
      'saved_descriptions': savedDescriptions.map((e) => e.toJson()).toList(),
      'last_completed_step': lastCompletedStep,
    };
  }
}

class SavedDescription {
  final int srNo;
  final String description;

  SavedDescription({required this.srNo, required this.description});

  factory SavedDescription.fromJson(Map<String, dynamic> json) {
    return SavedDescription(
      srNo: json['sr_no'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'sr_no': srNo, 'description': description};
  }
}

class Technician {
  final String id;
  final String name;

  Technician({required this.id, required this.name});

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
