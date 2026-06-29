class UnreadCountResponse {
  final int status;
  final bool success;
  final UnreadCountData? data;
  final String? message;

  const UnreadCountResponse({
    required this.status,
    required this.success,
    this.data,
    this.message,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      status: json['status'] as int,
      success: json['success'] as bool,
      data: json['data'] != null
          ? UnreadCountData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }
}

class UnreadCountData {
  final int unreadCount;

  const UnreadCountData({required this.unreadCount});

  factory UnreadCountData.fromJson(Map<String, dynamic> json) {
    return UnreadCountData(unreadCount: json['unread_count'] as int);
  }
}
