import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'translate_event.dart';
part 'translate_state.dart';

/// Handles state management for **Translation** and its related entities.
/// The BLoC persists the chosen locale via HydratedBloc so the selection
/// survives app restarts.

class TranslateBloc extends HydratedBloc<TranslateEvent, TranslateState> {
  TranslateBloc() : super(const TranslateState("en", "US")) {
    on<TrMarathiEvent>(_trMarathi);
    on<TrEnglishEvent>(_trEnglish);
  }

  Future<void> _trMarathi(TrMarathiEvent event, Emitter<TranslateState> emit) async {
    emit(const TranslateState("mr", "IN"));
  }

  Future<void> _trEnglish(TrEnglishEvent event, Emitter<TranslateState> emit) async {
    emit(const TranslateState("en", "US"));
  }

  @override
  TranslateState? fromJson(Map<String, dynamic> json) {
    return TranslateState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TranslateState state) {
    return state.toMap();
  }
}
