import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_check_feedback_usecase.dart';
import 'amc_check_feedback_event.dart';
import 'amc_check_feedback_state.dart';

class AmcCheckFeedbackBloc extends Bloc<AmcCheckFeedbackEvent, AmcCheckFeedbackState> {
  final GetAmcCheckFeedbackUseCase _useCase;

  AmcCheckFeedbackBloc(this._useCase) : super(AmcCheckFeedbackInitialState()) {
    on<CheckAmcFeedbackEvent>((event, emit) async {
      emit(AmcCheckFeedbackLoadingState());
      final result = await _useCase(event.amcVisitId);
      result.fold(
        (failure) => emit(AmcCheckFeedbackFailureState(failure.message)),
        (data) => emit(AmcCheckFeedbackSuccessState(data)),
      );
    });
  }
}
