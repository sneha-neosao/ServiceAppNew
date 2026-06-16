part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final NotificationsResponse response;
  final List<NotificationItem> notifications;
  final bool hasReachedMax;

  const NotificationsLoaded({
    required this.response,
    required this.notifications,
    this.hasReachedMax = false,
  });

  NotificationsLoaded copyWith({
    NotificationsResponse? response,
    List<NotificationItem>? notifications,
    bool? hasReachedMax,
  }) {
    return NotificationsLoaded(
      response: response ?? this.response,
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [response, notifications, hasReachedMax];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}
