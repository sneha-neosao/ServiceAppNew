class ProfileDetailsResponse {
  final int status;
  final bool success;
  final ProfileData data;
  final String message;

  ProfileDetailsResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: ProfileData.fromJson(json['data']),
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

class ProfileData {
  final String id;
  final String code;
  final String name;
  final String phone;
  final String email;
  final bool isActive;
  final Dealer dealer;

  ProfileData({
    required this.id,
    required this.code,
    required this.name,
    required this.phone,
    required this.email,
    required this.isActive,
    required this.dealer,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? false,
      dealer: Dealer.fromJson(json['dealer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'phone': phone,
      'email': email,
      'is_active': isActive,
      'dealer': dealer.toJson(),
    };
  }
}

class Dealer {
  final String id;
  final String name;
  final String code;

  Dealer({required this.id, required this.name, required this.code});

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }
}
