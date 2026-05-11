import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'translate_event.dart';
part 'translate_state.dart';

/// Handles state management for **Translation** and its related entities.

class TranslateBloc extends HydratedBloc<TranslateEvent, TranslateState> {
  TranslateBloc() : super(const TranslateState("mr", "IN", "US")) {
    on<TrMarathiEvent>(_trMarathi);
    on<TrEnglishEvent>(_trEnglish);
  }

  Future _trMarathi(TrMarathiEvent event, Emitter emit) async {
    emit(TranslateState("mr", "ID", state.countryCode));
  }

  Future _trEnglish(TrEnglishEvent event, Emitter emit) async {
    emit(TranslateState("en", "US", state.countryCode));
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
