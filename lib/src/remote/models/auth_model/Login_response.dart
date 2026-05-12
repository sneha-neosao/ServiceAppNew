import 'dart:convert';

class LoginResponse {
  final int status;
  final bool success;
  final String message;
  final String refreshToken;
  final String accessToken;
  final Technician technician;
  final Dealer dealer;

  LoginResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.refreshToken,
    required this.accessToken,
    required this.technician,
    required this.dealer,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      refreshToken: data['refresh_token'],
      accessToken: data['access_token'],
      technician: Technician.fromJson(data['technician']),
      dealer: Dealer.fromJson(data['dealer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': {
        'refresh_token': refreshToken,
        'access_token': accessToken,
        'technician': technician.toJson(),
        'dealer': dealer.toJson(),
      },
    };
  }

  /// Convert to raw JSON string for storage
  String toRawJson() => jsonEncode(toJson());

  /// Restore from raw JSON string
  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(jsonDecode(str));
}

class Technician {
  final String id;
  final String name;
  final String code;
  final String phone;
  final String email;

  Technician({
    required this.id,
    required this.name,
    required this.code,
    required this.phone,
    required this.email,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
      'email': email,
    };
  }
}

class Dealer {
  final String id;
  final String name;
  final String code;

  Dealer({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}
