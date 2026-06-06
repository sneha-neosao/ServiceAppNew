class SiteResponse {
  final int status;
  final bool success;
  final String message;
  final List<Site> data;

  SiteResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory SiteResponse.fromJson(Map<String, dynamic> json) {
    return SiteResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data']['results'] != null)
          ? (json['data']['results'] as List<dynamic>)
              .map((e) => Site.fromJson(e))
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

class Site {
  final String id;
  final String name;

  Site({required this.id, required this.name});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
