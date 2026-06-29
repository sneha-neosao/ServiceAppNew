class TechnicianResponse {
  final int status;
  final bool success;
  final String message;
  final List<Technician> data;

  TechnicianResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory TechnicianResponse.fromJson(Map<String, dynamic> json) {
    return TechnicianResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data']['results'] != null)
          ? (json['data']['results'] as List<dynamic>)
              .map((e) => Technician.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
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
