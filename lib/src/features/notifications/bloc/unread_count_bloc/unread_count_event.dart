import 'package:equatable/equatable.dart';

abstract class UnreadCountEvent extends Equatable {
  const UnreadCountEvent();

  @override
  List<Object?> get props => [];
}

class GetUnreadNotificationCountEvent extends UnreadCountEvent {
  const GetUnreadNotificationCountEvent();
}
