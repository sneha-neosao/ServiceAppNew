// ignore_for_file: non_constant_identifier_names

class NotificationsResponse {
  final int? status;
  final bool? success;
  final NotificationsData? data;
  final String? message;

  NotificationsResponse({
    this.status,
    this.success,
    this.data,
    this.message,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsResponse(
        status: json["status"],
        success: json["success"],
        data: json["data"] == null ? null : NotificationsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class NotificationsData {
  final List<NotificationItem>? results;
  final Pagination? pagination;

  NotificationsData({
    this.results,
    this.pagination,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      NotificationsData(
        results: json["results"] == null
            ? []
            : List<NotificationItem>.from(
                json["results"]!.map((x) => NotificationItem.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class NotificationItem {
  final String? id;
  final String? notificationType;
  final String? title;
  final String? message;
  final String? customerName;
  final String? siteName;
  final String? complaintNumber;
  final String? referenceNumber;
  final bool? isRead;
  final String? readAt;
  final String? createdAt;
  final String? sourceId;
  final String? sourceType;

  NotificationItem({
    this.id,
    this.notificationType,
    this.title,
    this.message,
    this.customerName,
    this.siteName,
    this.complaintNumber,
    this.referenceNumber,
    this.isRead,
    this.readAt,
    this.createdAt,
    this.sourceId,
    this.sourceType,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json["id"],
        notificationType: json["notification_type"],
        title: json["title"],
        message: json["message"],
        customerName: json["customer_name"],
        siteName: json["site_name"],
        complaintNumber: json["complaint_number"],
        referenceNumber: json["reference_number"],
        isRead: json["is_read"],
        readAt: json["read_at"],
        createdAt: json["created_at"],
        sourceId: json["source_id"],
        sourceType: json["source_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notification_type": notificationType,
        "title": title,
        "message": message,
        "customer_name": customerName,
        "site_name": siteName,
        "complaint_number": complaintNumber,
        "reference_number": referenceNumber,
        "is_read": isRead,
        "read_at": readAt,
        "created_at": createdAt,
        "source_id": sourceId,
        "source_type": sourceType,
      };
}

class Pagination {
  final int? page;
  final int? pageSize;
  final int? totalPages;
  final int? totalItems;

  Pagination({
    this.page,
    this.pageSize,
    this.totalPages,
    this.totalItems,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["page_size"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "page_size": pageSize,
        "total_pages": totalPages,
        "total_items": totalItems,
      };
}
