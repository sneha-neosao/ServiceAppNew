import 'dart:convert';

class AppUpdateResponse {
  final int status;
  final String message;
  final AppVersionData data;

  AppUpdateResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AppUpdateResponse.fromRawJson(String str) =>
      AppUpdateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUpdateResponse.fromJson(Map<String, dynamic> json) =>
      AppUpdateResponse(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        data: AppVersionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class AppVersionData {
  final PlatformVersion iosAppVersion;
  final PlatformVersion androidAppVersion;

  AppVersionData({
    required this.iosAppVersion,
    required this.androidAppVersion,
  });

  factory AppVersionData.fromJson(Map<String, dynamic> json) => AppVersionData(
    iosAppVersion: PlatformVersion.fromJson(json["ios_app_version"]),
    androidAppVersion: PlatformVersion.fromJson(json["android_app_version"]),
  );

  Map<String, dynamic> toJson() => {
    "ios_app_version": iosAppVersion.toJson(),
    "android_app_version": androidAppVersion.toJson(),
  };
}

class PlatformVersion {
  final String version;
  final bool forceUpdate;
  final String updateMessage;
  final String storeLink;

  PlatformVersion({
    required this.version,
    required this.forceUpdate,
    required this.updateMessage,
    required this.storeLink,
  });

  factory PlatformVersion.fromJson(Map<String, dynamic> json) =>
      PlatformVersion(
        version: json["version"] ?? "",
        forceUpdate: json["force_update"] ?? false,
        updateMessage: json["update_message"] ?? "",
        storeLink: json["store_link"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "version": version,
    "force_update": forceUpdate,
    "update_message": updateMessage,
    "store_link": storeLink,
  };
}
