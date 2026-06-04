import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_event.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/close_over_call_usecase.dart';

class CloseOverCallBloc extends Bloc<CloseOverCallEvent, CloseOverCallState> {
  final CloseOverCallUsecase closeOverCallUsecase;

  CloseOverCallBloc({required this.closeOverCallUsecase})
    : super(CloseOverCallInitialState()) {
    on<CloseOverCallPostEvent>(_onPostCloseOverCall);
  }

  Future<void> _onPostCloseOverCall(
    CloseOverCallPostEvent event,
    Emitter<CloseOverCallState> emit,
  ) async {
    emit(CloseOverCallLoadingState());

    final result = await closeOverCallUsecase(event.params);

    result.fold(
      (failure) => emit(CloseOverCallFailureState(failure.message)),
      (data) => emit(CloseOverCallSuccessState(data)),
    );
  }
}
