part of 'splash_bloc.dart';

/// Base state for the Splash BLoC.
///
/// Holds the [time] value which can represent how long the splash screen
/// has been displayed or elapsed time.
sealed class SplashState extends Equatable {
  final int time;
  const SplashState({
    required this.time,
  });
  @override
  List<Object?> get props => [
        time,
      ];
}

/// Initial state of the splash screen.
///
/// Typically represents the starting point before the timer begins.
class SplashInitialState extends SplashState {
  final int time;
  const SplashInitialState({
    required this.time,
  })
      : super(time: time);
}

/// State representing splash screen data after the timer completes.
///
/// Here, [time] is set to 0 to indicate that the splash timer has finished.
class SplashDataState extends SplashState {
  const SplashDataState() : super(
          time: 0
        );
  @override
  List<Object?> get props => [
        time
      ];
}
