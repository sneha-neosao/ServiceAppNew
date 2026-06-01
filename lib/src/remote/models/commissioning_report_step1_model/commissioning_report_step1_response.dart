import 'package:equatable/equatable.dart';

class CommissioningStep1Response extends Equatable {
  final int status;
  final bool success;
  final CommissioningStep1Data data;
  final String message;

  const CommissioningStep1Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningStep1Response.fromJson(Map<String, dynamic> json) {
    return CommissioningStep1Response(
      status: json['status'],
      success: json['success'],
      data: CommissioningStep1Data.fromJson(json['data']),
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

class CommissioningStep1Data extends Equatable {
  final String id;
  final String commissioningWorkId;
  final String dealerName;
  final String customerName;
  final String siteName;
  final String applicationOfEquipment;
  final List<Technician> assignedTechnicians;
  final int lastCompletedStep;

  const CommissioningStep1Data({
    required this.id,
    required this.commissioningWorkId,
    required this.dealerName,
    required this.customerName,
    required this.siteName,
    required this.applicationOfEquipment,
    required this.assignedTechnicians,
    required this.lastCompletedStep,
  });

  factory CommissioningStep1Data.fromJson(Map<String, dynamic> json) {
    return CommissioningStep1Data(
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

  @override
  List<Object?> get props => [
    id,
    commissioningWorkId,
    dealerName,
    customerName,
    siteName,
    applicationOfEquipment,
    assignedTechnicians,
    lastCompletedStep,
  ];
}

class Technician extends Equatable {
  final String id;
  final String name;

  const Technician({
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

  @override
  List<Object?> get props => [id, name];
}
