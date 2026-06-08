import 'package:equatable/equatable.dart';

sealed class ServiceCallDetailsEvent extends Equatable {
  const ServiceCallDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCallDetailsGetEvent extends ServiceCallDetailsEvent {
  final String id;

  const ServiceCallDetailsGetEvent(this.id);

  @override
  List<Object?> get props => [id];
}
