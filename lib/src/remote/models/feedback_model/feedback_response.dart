class FeedbackResponse {
  final int status;
  final bool success;
  final FeedbackData? data;
  final String message;

  FeedbackResponse({
    required this.status,
    required this.success,
    this.data,
    required this.message,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] != null ? FeedbackData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
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

class FeedbackData {
  final bool feedbackSubmitted;
  final FeedbackDetails? feedback;

  FeedbackData({required this.feedbackSubmitted, this.feedback});

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      feedbackSubmitted: json['feedback_submitted'] ?? false,
      feedback: json['feedback'] != null
          ? FeedbackDetails.fromJson(json['feedback'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_submitted': feedbackSubmitted,
      'feedback': feedback?.toJson(),
    };
  }
}

class FeedbackDetails {
  final String id;
  final String name;
  final String contactNumber;
  final bool issueResolved;
  final int rating;
  final String technicianBehavior;
  final String shortComment;
  final String? submittedByTechnicianName;
  final String? submittedByTechnicianCode;
  final String? submittedByTechnicianPhone;
  final String createdAt;

  FeedbackDetails({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.issueResolved,
    required this.rating,
    required this.technicianBehavior,
    required this.shortComment,
    this.submittedByTechnicianName,
    this.submittedByTechnicianCode,
    this.submittedByTechnicianPhone,
    required this.createdAt,
  });

  factory FeedbackDetails.fromJson(Map<String, dynamic> json) {
    return FeedbackDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      issueResolved: json['issue_resolved'] ?? false,
      rating: json['rating'] ?? 0,
      technicianBehavior: json['technician_behavior'] ?? '',
      shortComment: json['short_comment'] ?? '',
      submittedByTechnicianName: json['submitted_by_technician_name'],
      submittedByTechnicianCode: json['submitted_by_technician_code'],
      submittedByTechnicianPhone: json['submitted_by_technician_phone'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact_number': contactNumber,
      'issue_resolved': issueResolved,
      'rating': rating,
      'technician_behavior': technicianBehavior,
      'short_comment': shortComment,
      'submitted_by_technician_name': submittedByTechnicianName,
      'submitted_by_technician_code': submittedByTechnicianCode,
      'submitted_by_technician_phone': submittedByTechnicianPhone,
      'created_at': createdAt,
    };
  }
}
