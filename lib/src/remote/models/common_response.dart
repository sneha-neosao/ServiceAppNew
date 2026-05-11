import 'dart:convert';

class CommonResponse {
  dynamic status;
  String? message;
  String? extra;

  CommonResponse({
    required this.status,
    required this.message,
     this.extra,
  });

  factory CommonResponse.fromRawJson(String str) => CommonResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
    status: json["status"],
    message: json["message"],
    extra: json["extra"]??"",
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) {
      map['status'] = status;
    }
    if (message != null) {
      map['message'] = message;
    }
    if (extra != null) {
      map['extra'] = extra;
    }
    return map;
  }
}