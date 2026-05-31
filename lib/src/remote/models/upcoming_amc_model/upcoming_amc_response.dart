class UpcomingAmcVisitsResponse {
  final int? status;
  final bool? success;
  final UpcomingAmcVisitsData? data;
  final String? message;

  UpcomingAmcVisitsResponse({
    this.status,
    this.success,
    this.data,
    this.message,
  });

  factory UpcomingAmcVisitsResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingAmcVisitsResponse(
      status: json['status'],
      success: json['success'],
      data: json['data'] != null
          ? UpcomingAmcVisitsData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class UpcomingAmcVisitsData {
  final String? filter;
  final String? rangeStart;
  final String? rangeEnd;
  final int? total;
  final List<AmcVisit>? visits;

  UpcomingAmcVisitsData({
    this.filter,
    this.rangeStart,
    this.rangeEnd,
    this.total,
    this.visits,
  });

  factory UpcomingAmcVisitsData.fromJson(Map<String, dynamic> json) {
    return UpcomingAmcVisitsData(
      filter: json['filter'],
      rangeStart: json['range_start'],
      rangeEnd: json['range_end'],
      total: json['total'],
      visits: (json['visits'] as List<dynamic>?)
          ?.map((e) => AmcVisit.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'range_start': rangeStart,
      'range_end': rangeEnd,
      'total': total,
      'visits': visits?.map((e) => e.toJson()).toList(),
    };
  }
}

class AmcVisit {
  AmcVisit();

  factory AmcVisit.fromJson(Map<String, dynamic> json) {
    return AmcVisit();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}