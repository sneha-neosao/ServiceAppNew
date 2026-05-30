part of 'sites_bloc.dart';

sealed class SitesState extends Equatable {
  const SitesState();
  @override
  List<Object?> get props => [];
}

class SitesinitialState extends SitesState {}

/// States like loading, success and failure representing Technician fetching.

class SitesLoadingState extends SitesState {}

class SitesSuccessState extends SitesState {
  final SiteResponse data;

  const SitesSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class SitesFailureState extends SitesState {
  final String message;

  const SitesFailureState(this.message);

  @override
  List<Object?> get props => [message];
}