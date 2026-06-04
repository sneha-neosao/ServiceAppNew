class ActiveTechniciansServiceCallsResponse {
  final int status;
  final bool success;
  final List<Technician> data;
  final String message;

  ActiveTechniciansServiceCallsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ActiveTechniciansServiceCallsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActiveTechniciansServiceCallsResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Technician.fromJson(e))
              .toList() ??
          [],
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
}

class Technician {
  final String id;
  final String name;
  final String code;

  Technician({required this.id, required this.name, required this.code});

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }
}
