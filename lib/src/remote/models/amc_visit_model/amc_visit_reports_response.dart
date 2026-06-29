import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_list_response.dart';

class AmcVisitReportsResponse {
  final int status;
  final bool success;
  final AmcVisitReportsData data;
  final String message;

  AmcVisitReportsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcVisitReportsResponse.fromJson(Map<String, dynamic> json) {
    return AmcVisitReportsResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: AmcVisitReportsData.fromJson(json['data'] ?? {}),
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
}

class AmcVisitReportsData {
  final VisitInfo visit;
  final List<AmcVisitData> reports;

  AmcVisitReportsData({required this.visit, required this.reports});

  factory AmcVisitReportsData.fromJson(Map<String, dynamic> json) {
    return AmcVisitReportsData(
      visit: VisitInfo.fromJson(json['visit'] ?? {}),
      reports:
          (json['reports'] as List<dynamic>?)
              ?.map((e) => AmcVisitData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit': visit.toJson(),
      'reports': reports.map((e) => e.toJson()).toList(),
    };
  }
}

class VisitInfo {
  final String id;
  final int visitNumber;
  final String fromDate;
  final String toDate;
  final String status;

  VisitInfo({
    required this.id,
    required this.visitNumber,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  factory VisitInfo.fromJson(Map<String, dynamic> json) {
    return VisitInfo(
      id: json['id'] ?? '',
      visitNumber: json['visit_number'] ?? 0,
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_number': visitNumber,
      'from_date': fromDate,
      'to_date': toDate,
      'status': status,
    };
  }
}
