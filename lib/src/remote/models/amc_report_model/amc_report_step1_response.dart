import 'package:equatable/equatable.dart';

class AmcReportStep1Response extends Equatable {
  final int status;
  final bool success;
  final AmcReportStep1Data data;
  final String message;

  const AmcReportStep1Response({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcReportStep1Response.fromJson(Map<String, dynamic> json) {
    return AmcReportStep1Response(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: AmcReportStep1Data.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
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

class AmcReportStep1Data extends Equatable {
  final String id;
  final String memberPresentsCustomerSide;
  final String agenda;
  final String dealerName;
  final String customerName;
  final String siteName;
  final List<AssignedTechnician> assignedTechnicians;
  final int lastCompletedStep;

  const AmcReportStep1Data({
    required this.id,
    required this.memberPresentsCustomerSide,
    required this.agenda,
    required this.dealerName,
    required this.customerName,
    required this.siteName,
    required this.assignedTechnicians,
    required this.lastCompletedStep,
  });

  factory AmcReportStep1Data.fromJson(Map<String, dynamic> json) {
    String parseStringOrList(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is List) {
        return value.map((e) => e.toString()).join(', ');
      }
      return value.toString();
    }

    return AmcReportStep1Data(
      id: json['id']?.toString() ?? '',
      memberPresentsCustomerSide: parseStringOrList(
        json['member_presents_customer_side'],
      ),
      agenda: json['agenda']?.toString() ?? '',
      dealerName: json['dealer_name']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      siteName: json['site_name']?.toString() ?? '',
      assignedTechnicians: (json['assigned_technicians'] as List? ?? [])
          .map((e) => AssignedTechnician.fromJson(e))
          .toList(),
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_presents_customer_side': memberPresentsCustomerSide,
      'agenda': agenda,
      'dealer_name': dealerName,
      'customer_name': customerName,
      'site_name': siteName,
      'assigned_technicians': assignedTechnicians
          .map((e) => e.toJson())
          .toList(),
      'last_completed_step': lastCompletedStep,
    };
  }

  @override
  List<Object?> get props => [
    id,
    memberPresentsCustomerSide,
    agenda,
    dealerName,
    customerName,
    siteName,
    assignedTechnicians,
    lastCompletedStep,
  ];
}

class AssignedTechnician extends Equatable {
  final String id;
  final String name;

  const AssignedTechnician({required this.id, required this.name});

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}
