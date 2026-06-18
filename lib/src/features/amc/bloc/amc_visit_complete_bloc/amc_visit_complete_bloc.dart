import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_visit_complete_usecase.dart';
import 'amc_visit_complete_event.dart';
import 'amc_visit_complete_state.dart';

class AmcVisitCompleteBloc extends Bloc<AmcVisitCompleteEvent, AmcVisitCompleteState> {
  final PostAmcVisitCompleteUseCase _useCase;

  AmcVisitCompleteBloc(this._useCase) : super(AmcVisitCompleteInitialState()) {
    on<SubmitAmcVisitCompleteEvent>((event, emit) async {
      emit(AmcVisitCompleteLoadingState());
      final result = await _useCase(event.visitId);
      result.fold(
        (failure) => emit(AmcVisitCompleteFailureState((failure as dynamic).message)),
        (data) => emit(AmcVisitCompleteSuccessState(data)),
      );
    });
  }
}
