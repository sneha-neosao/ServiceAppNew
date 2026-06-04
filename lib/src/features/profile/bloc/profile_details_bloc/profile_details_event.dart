part of 'profile_details_bloc.dart';

/// Event for fetching profile details .

sealed class ProfileDetailsEvent extends Equatable {
  const ProfileDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ProfileDetailsGetEvent extends ProfileDetailsEvent {
  const ProfileDetailsGetEvent();

  @override
  List<Object?> get props => [];
}
