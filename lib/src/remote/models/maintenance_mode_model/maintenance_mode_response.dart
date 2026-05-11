import 'dart:convert';

class MaintenanceModeResponse {
  final int status;
  final String message;
  final MaintenanceData data;

  MaintenanceModeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MaintenanceModeResponse.fromRawJson(String str) =>
      MaintenanceModeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaintenanceModeResponse.fromJson(Map<String, dynamic> json) =>
      MaintenanceModeResponse(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        data: MaintenanceData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class MaintenanceData {
  final int maintenanceMode;

  MaintenanceData({required this.maintenanceMode});

  factory MaintenanceData.fromJson(Map<String, dynamic> json) => MaintenanceData(
    maintenanceMode: json["maintenance_mode"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "maintenance_mode": maintenanceMode,
  };
}
