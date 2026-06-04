import 'package:equatable/equatable.dart';

class CommissioningReportStep2AutoFillResponse extends Equatable {
  final int status;
  final bool success;
  final CommissioningStep2Data data;
  final String message;

  const CommissioningReportStep2AutoFillResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportStep2AutoFillResponse.fromJson(Map<String, dynamic> json) {
    return CommissioningReportStep2AutoFillResponse(
      status: json['status'],
      success: json['success'],
      data: CommissioningStep2Data.fromJson(json['data']),
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

class CommissioningStep2Data extends Equatable {
  final String id;
  final int warrantyPeriodYears;
  final String warrantyStartDate;
  final String warrantyExpiryDate;
  final String warrantyStatus;
  final List<String> memberPresentsCustomerSide;
  final String agenda;
  final int lastCompletedStep;

  const CommissioningStep2Data({
    required this.id,
    required this.warrantyPeriodYears,
    required this.warrantyStartDate,
    required this.warrantyExpiryDate,
    required this.warrantyStatus,
    required this.memberPresentsCustomerSide,
    required this.agenda,
    required this.lastCompletedStep,
  });

  factory CommissioningStep2Data.fromJson(Map<String, dynamic> json) {
    return CommissioningStep2Data(
      id: json['id'] ?? '',
      warrantyPeriodYears: json['warranty_period_years'] ?? 0,
      warrantyStartDate: json['warranty_start_date'] ?? '',
      warrantyExpiryDate: json['warranty_expiry_date'] ?? '',
      warrantyStatus: json['warranty_status'] ?? '',
      memberPresentsCustomerSide: json['member_presents_customer_side'] != null
          ? List<String>.from(json['member_presents_customer_side'])
          : [],
      agenda: json['agenda'] ?? '',
      lastCompletedStep: json['last_completed_step'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'warranty_period_years': warrantyPeriodYears,
      'warranty_start_date': warrantyStartDate,
      'warranty_expiry_date': warrantyExpiryDate,
      'warranty_status': warrantyStatus,
      'member_presents_customer_side': memberPresentsCustomerSide,
      'agenda': agenda,
      'last_completed_step': lastCompletedStep,
    };
  }

  @override
  List<Object?> get props => [
    id,
    warrantyPeriodYears,
    warrantyStartDate,
    warrantyExpiryDate,
    warrantyStatus,
    memberPresentsCustomerSide,
    agenda,
    lastCompletedStep,
  ];
}
