part of 'sites_bloc.dart';

/// Event for authentication related information.

sealed class SitesEvent extends Equatable {
  const SitesEvent();

  @override
  List<Object?> get props => [];
}

/// Event for Sites.

class SitesGetEvent extends SitesEvent {
  final String customer_id;

  const SitesGetEvent(this.customer_id);

  @override
  List<Object?> get props => [customer_id];
}
