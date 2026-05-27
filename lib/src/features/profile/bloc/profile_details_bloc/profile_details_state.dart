part of 'profile_details_bloc.dart';

sealed class ProfileDetailsState extends Equatable {
  const ProfileDetailsState();
  @override
  List<Object?> get props => [];
}

class ProfileDetailsInitialState extends ProfileDetailsState {}

/// States like loading, success and failure representing profile details.

class ProfileDetailsLoadingState extends ProfileDetailsState {}

class ProfileDetailsSuccessState extends ProfileDetailsState {
  final ProfileDetailsResponse data;

  const ProfileDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ProfileDetailsFailureState extends ProfileDetailsState {
  final String message;

  const ProfileDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
