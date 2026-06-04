import 'package:equatable/equatable.dart';

class CommissioningReportFeedbackStatusCheckResponse extends Equatable {
  final int status;
  final bool success;
  final FeedbackStatusData data;
  final String message;

  const CommissioningReportFeedbackStatusCheckResponse({
    required this.status,
    required this.success,
    required this.data,
    required this.message,
  });

  factory CommissioningReportFeedbackStatusCheckResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CommissioningReportFeedbackStatusCheckResponse(
      status: json['status'],
      success: json['success'],
      data: FeedbackStatusData.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data.toJson(),
    'message': message,
  };

  @override
  List<Object?> get props => [status, success, data, message];
}

class FeedbackStatusData extends Equatable {
  final bool feedbackSubmitted;

  const FeedbackStatusData({required this.feedbackSubmitted});

  factory FeedbackStatusData.fromJson(Map<String, dynamic> json) {
    return FeedbackStatusData(feedbackSubmitted: json['feedback_submitted']);
  }

  Map<String, dynamic> toJson() => {'feedback_submitted': feedbackSubmitted};

  @override
  List<Object?> get props => [feedbackSubmitted];
}
