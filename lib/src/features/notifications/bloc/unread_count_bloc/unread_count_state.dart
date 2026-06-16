part of 'unread_count_bloc.dart';

abstract class UnreadCountState extends Equatable {
  const UnreadCountState();

  @override
  List<Object?> get props => [];
}

class UnreadCountInitial extends UnreadCountState {}

class UnreadCountLoading extends UnreadCountState {}

class UnreadCountLoaded extends UnreadCountState {
  final int unreadCount;

  const UnreadCountLoaded({required this.unreadCount});

  @override
  List<Object?> get props => [unreadCount];
}

class UnreadCountError extends UnreadCountState {
  final String message;

  const UnreadCountError({required this.message});

  @override
  List<Object?> get props => [message];
}
