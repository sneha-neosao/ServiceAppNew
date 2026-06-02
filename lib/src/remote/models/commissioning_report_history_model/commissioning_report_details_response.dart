class CommissioningDetailsResponse {
  final int? status;
  final bool? success;
  final CommissioningDetailsData? data;
  final String? message;

  CommissioningDetailsResponse({
    this.status,
    this.success,
    this.data,
    this.message,
  });

  factory CommissioningDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningDetailsResponse(
      status: json['status'],
      success: json['success'],
      data: json['data'] != null
          ? CommissioningDetailsData.fromJson(json['data'])
          : null,
      message: json['message'],
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

class CommissioningDetailsData {
  final String? id;
  final List<AssignedTechnician>? assignedTechnicians;
  final List<dynamic>? maintenanceChecklists;
  final List<DescriptionModel>? descriptions;
  final List<String>? mediaFiles;

  final String? dealerName;
  final String? customerName;
  final String? siteName;
  final String? applicationOfEquipment;
  final String? technicianRepresentativeName;

  final String? createdAt;
  final String? updatedAt;
  final bool? isDeleted;

  final List<String>? memberPresentsCustomerSide;

  final String? agenda;
  final String? warrantyStartDate;
  final String? warrantyExpiryDate;
  final int? warrantyPeriodYears;
  final String? warrantyStatus;

  final Map<String, dynamic>? pumpDetails;
  final Map<String, dynamic>? driverDetails;
  final Map<String, dynamic>? panelDetails;

  final bool? isTechnicalNa;
  final TechnicalDetails? technicalDetails;

  final bool? isMechanicalChecklistNa;
  final bool? isPipelineChecklistNa;
  final bool? isElectricalChecklistNa;

  final String? technicianRemarks;
  final String? customerRemarks;

  final String? customerRepresentativeName;
  final String? technicianRepresentativeCode;
  final String? technicianRepresentativePhone;

  final String? customerSignature;
  final String? technicianSignature;

  final String? status;
  final int? lastCompletedStep;
  final String? submittedAt;
  final bool? feedbackSubmitted;

  final String? createdByTechnicianName;
  final String? createdByTechnicianCode;
  final String? createdByTechnicianPhone;

  final String? dealer;
  final String? commissioningWork;
  final String? technicianRepresentative;
  final String? createdByDealerUser;
  final String? createdByTechnician;

  CommissioningDetailsData({
    this.id,
    this.assignedTechnicians,
    this.maintenanceChecklists,
    this.descriptions,
    this.mediaFiles,
    this.dealerName,
    this.customerName,
    this.siteName,
    this.applicationOfEquipment,
    this.technicianRepresentativeName,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.memberPresentsCustomerSide,
    this.agenda,
    this.warrantyStartDate,
    this.warrantyExpiryDate,
    this.warrantyPeriodYears,
    this.warrantyStatus,
    this.pumpDetails,
    this.driverDetails,
    this.panelDetails,
    this.isTechnicalNa,
    this.technicalDetails,
    this.isMechanicalChecklistNa,
    this.isPipelineChecklistNa,
    this.isElectricalChecklistNa,
    this.technicianRemarks,
    this.customerRemarks,
    this.customerRepresentativeName,
    this.technicianRepresentativeCode,
    this.technicianRepresentativePhone,
    this.customerSignature,
    this.technicianSignature,
    this.status,
    this.lastCompletedStep,
    this.submittedAt,
    this.feedbackSubmitted,
    this.createdByTechnicianName,
    this.createdByTechnicianCode,
    this.createdByTechnicianPhone,
    this.dealer,
    this.commissioningWork,
    this.technicianRepresentative,
    this.createdByDealerUser,
    this.createdByTechnician,
  });

  factory CommissioningDetailsData.fromJson(Map<String, dynamic> json) {
    return CommissioningDetailsData(
      id: json['id'],
      assignedTechnicians: (json['assigned_technicians'] as List?)
          ?.map((e) => AssignedTechnician.fromJson(e))
          .toList(),
      maintenanceChecklists: json['maintenance_checklists'],
      descriptions: (json['descriptions'] as List?)
          ?.map((e) => DescriptionModel.fromJson(e))
          .toList(),
      mediaFiles: List<String>.from(json['media_files'] ?? []),
      dealerName: json['dealer_name'],
      customerName: json['customer_name'],
      siteName: json['site_name'],
      applicationOfEquipment: json['application_of_equipment'],
      technicianRepresentativeName:
      json['technician_representative_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'],
      memberPresentsCustomerSide:
      List<String>.from(json['member_presents_customer_side'] ?? []),
      agenda: json['agenda'],
      warrantyStartDate: json['warranty_start_date'],
      warrantyExpiryDate: json['warranty_expiry_date'],
      warrantyPeriodYears: json['warranty_period_years'],
      warrantyStatus: json['warranty_status'],
      pumpDetails: json['pump_details'],
      driverDetails: json['driver_details'],
      panelDetails: json['panel_details'],
      isTechnicalNa: json['is_technical_na'],
      technicalDetails: json['technical_details'] != null
          ? TechnicalDetails.fromJson(json['technical_details'])
          : null,
      isMechanicalChecklistNa: json['is_mechanical_checklist_na'],
      isPipelineChecklistNa: json['is_pipeline_checklist_na'],
      isElectricalChecklistNa: json['is_electrical_checklist_na'],
      technicianRemarks: json['technician_remarks'],
      customerRemarks: json['customer_remarks'],
      customerRepresentativeName:
      json['customer_representative_name'],
      technicianRepresentativeCode:
      json['technician_representative_code'],
      technicianRepresentativePhone:
      json['technician_representative_phone'],
      customerSignature: json['customer_signature'],
      technicianSignature: json['technician_signature'],
      status: json['status'],
      lastCompletedStep: json['last_completed_step'],
      submittedAt: json['submitted_at'],
      feedbackSubmitted: json['feedback_submitted'],
      createdByTechnicianName:
      json['created_by_technician_name'],
      createdByTechnicianCode:
      json['created_by_technician_code'],
      createdByTechnicianPhone:
      json['created_by_technician_phone'],
      dealer: json['dealer'],
      commissioningWork: json['commissioning_work'],
      technicianRepresentative:
      json['technician_representative'],
      createdByDealerUser: json['created_by_dealer_user'],
      createdByTechnician: json['created_by_technician'],
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class AssignedTechnician {
  final String? id;
  final String? name;

  AssignedTechnician({
    this.id,
    this.name,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class DescriptionModel {
  final int? srNo;
  final String? description;

  DescriptionModel({
    this.srNo,
    this.description,
  });

  factory DescriptionModel.fromJson(Map<String, dynamic> json) {
    return DescriptionModel(
      srNo: json['sr_no'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'sr_no': srNo,
    'description': description,
  };
}

class TechnicalDetails {
  final String? rpm;
  final String? pumpMake;
  final String? ratingHp;
  final String? ratingKw;
  final String? pumpModel;
  final String? driverMake;
  final String? pumpFlowLpm;
  final String? pumpFlowLps;
  final String? pumpHeadMtr;
  final String? pumpFlowM3hr;
  final String? pumpFlowUsgpm;
  final String? controlPanelMake;
  final String? panelSerialModel;
  final String? pumpSerialNumber;
  final String? driverSerialNumber;

  TechnicalDetails({
    this.rpm,
    this.pumpMake,
    this.ratingHp,
    this.ratingKw,
    this.pumpModel,
    this.driverMake,
    this.pumpFlowLpm,
    this.pumpFlowLps,
    this.pumpHeadMtr,
    this.pumpFlowM3hr,
    this.pumpFlowUsgpm,
    this.controlPanelMake,
    this.panelSerialModel,
    this.pumpSerialNumber,
    this.driverSerialNumber,
  });

  factory TechnicalDetails.fromJson(Map<String, dynamic> json) {
    return TechnicalDetails(
      rpm: json['rpm'],
      pumpMake: json['pump_make'],
      ratingHp: json['rating_hp'],
      ratingKw: json['rating_kw'],
      pumpModel: json['pump_model'],
      driverMake: json['driver_make'],
      pumpFlowLpm: json['pump_flow_lpm'],
      pumpFlowLps: json['pump_flow_lps'],
      pumpHeadMtr: json['pump_head_mtr'],
      pumpFlowM3hr: json['pump_flow_m3hr'],
      pumpFlowUsgpm: json['pump_flow_usgpm'],
      controlPanelMake: json['control_panel_make'],
      panelSerialModel: json['panel_serial_model'],
      pumpSerialNumber: json['pump_serial_number'],
      driverSerialNumber: json['driver_serial_number'],
    );
  }

  Map<String, dynamic> toJson() => {
    'rpm': rpm,
    'pump_make': pumpMake,
    'rating_hp': ratingHp,
    'rating_kw': ratingKw,
    'pump_model': pumpModel,
    'driver_make': driverMake,
    'pump_flow_lpm': pumpFlowLpm,
    'pump_flow_lps': pumpFlowLps,
    'pump_head_mtr': pumpHeadMtr,
    'pump_flow_m3hr': pumpFlowM3hr,
    'pump_flow_usgpm': pumpFlowUsgpm,
    'control_panel_make': controlPanelMake,
    'panel_serial_model': panelSerialModel,
    'pump_serial_number': pumpSerialNumber,
    'driver_serial_number': driverSerialNumber,
  };
}