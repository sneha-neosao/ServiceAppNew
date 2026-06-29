import 'package:equatable/equatable.dart';

class AmcAssignedTechniciansResponse extends Equatable {
  final int status;
  final bool success;
  final List<AmcAssignedTechnician> data;
  final String message;

  const AmcAssignedTechniciansResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory AmcAssignedTechniciansResponse.fromJson(Map<String, dynamic> json) {
    return AmcAssignedTechniciansResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: (json['data'] != null && json['data']['results'] != null)
          ? (json['data']['results'] as List<dynamic>)
                .map((e) => AmcAssignedTechnician.fromJson(e))
                .toList()
          : [],
      message: json['message'] ?? '',
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

class AmcAssignedTechnician extends Equatable {
  final String assignId;
  final String technicianId;
  final String name;

  const AmcAssignedTechnician({
    required this.assignId,
    required this.technicianId,
    required this.name,
  });

  factory AmcAssignedTechnician.fromJson(Map<String, dynamic> json) {
    return AmcAssignedTechnician(
      assignId: json['assign_id'] ?? '',
      technicianId: json['technician_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'assign_id': assignId, 'technician_id': technicianId, 'name': name};
  }

  @override
  List<Object?> get props => [assignId, technicianId, name];
}
