import 'package:equatable/equatable.dart';

abstract class MarkAllReadEvent extends Equatable {
  const MarkAllReadEvent();

  @override
  List<Object?> get props => [];
}

class MarkAllNotificationsReadEvent extends MarkAllReadEvent {
  const MarkAllNotificationsReadEvent();
}
