import 'package:equatable/equatable.dart';

class AssignedTechnicianResponse extends Equatable {
  final int status;
  final bool success;
  final List<AssignedTechnician> data;
  final String message;

  const AssignedTechnicianResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AssignedTechnicianResponse.fromJson(Map<String, dynamic> json) {
    return AssignedTechnicianResponse(
      status: json['status'],
      success: json['success'],
      data: (json['data'] != null && json['data'] is Map && json['data']['results'] != null)
          ? (json['data']['results'] as List)
              .map((e) => AssignedTechnician.fromJson(e))
              .toList()
          : (json['data'] as List?)
                  ?.map((e) => AssignedTechnician.fromJson(e))
                  .toList() ??
              [],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }

  @override
  List<Object?> get props => [status, success, data, message];
}

class AssignedTechnician extends Equatable {
  final String assignId;
  final String technicianId;
  final String name;

  const AssignedTechnician({
    required this.assignId,
    required this.technicianId,
    required this.name,
  });

  factory AssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AssignedTechnician(
      assignId: json['assign_id'],
      technicianId: json['technician_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'assign_id': assignId, 'technician_id': technicianId, 'name': name};
  }

  @override
  List<Object?> get props => [assignId, technicianId, name];
}
