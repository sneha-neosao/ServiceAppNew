import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

/// Handles state management for **Splash** and its related entities.

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitialState(time: 1000)) {
    on<SplashTimerCompletedEvent>(_splashTimer);
    add(SplashTimerCompletedEvent(2000));
  }

  ///   - Splash timer setting
  Future _splashTimer(SplashTimerCompletedEvent event, Emitter emit) async {

    await Future.delayed(Duration(milliseconds:event.time), () async {
      emit(
        SplashDataState(),
      );
    });

  }

  @override
  Future<void> close() {
    return super.close();
  }
}
