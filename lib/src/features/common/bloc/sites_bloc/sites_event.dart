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
  final int page;
  final int pageSize;
  final String search;

  const SitesGetEvent({
    required this.customer_id,
    this.page = 1,
    this.pageSize = 10,
    this.search = '',
  });

  @override
  List<Object?> get props => [customer_id, page, pageSize, search];
}
