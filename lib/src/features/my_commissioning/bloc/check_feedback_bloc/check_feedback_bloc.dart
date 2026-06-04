import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_check_feedback_usecase.dart';
import 'check_feedback_event.dart';
import 'check_feedback_state.dart';

class CheckFeedbackBloc extends Bloc<CheckFeedbackEvent, CheckFeedbackState> {
  final CommissioningReportCheckFeedbackUsecase usecase;

  CheckFeedbackBloc({required this.usecase}) : super(CheckFeedbackInitial()) {
    on<FetchCheckFeedbackEvent>((event, emit) async {
      emit(CheckFeedbackLoading());
      final result = await usecase(event.reportId);
      result.fold(
        (failure) => emit(CheckFeedbackError(message: failure.message)),
        (response) {
          if (response.success) {
            emit(CheckFeedbackLoaded(response: response));
          } else {
            emit(CheckFeedbackError(message: response.message));
          }
        },
      );
    });
  }
}
