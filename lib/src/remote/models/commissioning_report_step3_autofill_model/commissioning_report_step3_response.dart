import 'package:equatable/equatable.dart';

class CommissioningStep3Response extends Equatable {
  final int status;
  final bool success;
  final CommissioningStep3Data data;
  final String message;

  const CommissioningStep3Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningStep3Response.fromJson(Map<String, dynamic> json) {
    return CommissioningStep3Response(
      status: json['status'],
      success: json['success'],
      data: CommissioningStep3Data.fromJson(json['data']),
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

class CommissioningStep3Data extends Equatable {
  final String id;
  final bool isTechnicalNa;
  final TechnicalDetails? technicalDetails;
  final int lastCompletedStep;

  const CommissioningStep3Data({
    required this.id,
    required this.isTechnicalNa,
    this.technicalDetails,
    required this.lastCompletedStep,
  });

  factory CommissioningStep3Data.fromJson(Map<String, dynamic> json) {
    return CommissioningStep3Data(
      id: json['id'],
      isTechnicalNa: json['is_technical_na'],
      technicalDetails:
          (json['technical_details'] != null &&
              (json['technical_details'] as Map).isNotEmpty)
          ? TechnicalDetails.fromJson(json['technical_details'])
          : null,
      lastCompletedStep: json['last_completed_step'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_technical_na': isTechnicalNa,
      'technical_details': technicalDetails?.toJson() ?? {},
      'last_completed_step': lastCompletedStep,
    };
  }

  @override
  List<Object?> get props => [
    id,
    isTechnicalNa,
    technicalDetails,
    lastCompletedStep,
  ];
}

class TechnicalDetails extends Equatable {
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

  const TechnicalDetails({
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

  Map<String, dynamic> toJson() {
    return {
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

  @override
  List<Object?> get props => [
    rpm,
    pumpMake,
    ratingHp,
    ratingKw,
    pumpModel,
    driverMake,
    pumpFlowLpm,
    pumpFlowLps,
    pumpHeadMtr,
    pumpFlowM3hr,
    pumpFlowUsgpm,
    controlPanelMake,
    panelSerialModel,
    pumpSerialNumber,
    driverSerialNumber,
  ];
}
