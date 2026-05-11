part of 'splash_bloc.dart';

/// Base class for all Splash BLoC events.
///
/// Extends [Equatable] to enable efficient state updates by comparing events.
sealed class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the splash screen timer completes.
///
/// Carries the [time] duration for which the splash screen was shown,
/// which can be used for analytics or timed navigation logic.
class SplashTimerCompletedEvent extends SplashEvent {
  final int  time;

  const SplashTimerCompletedEvent(this.time);

  @override
  List<Object?> get props => [time];
}
