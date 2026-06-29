import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_check_feedback_usecase.dart';
import 'service_call_check_feedback_event.dart';
import 'service_call_check_feedback_state.dart';

class ServiceCallCheckFeedbackBloc
    extends Bloc<ServiceCallCheckFeedbackEvent, ServiceCallCheckFeedbackState> {
  final ServiceCallCheckFeedbackUsecase usecase;

  ServiceCallCheckFeedbackBloc({required this.usecase})
      : super(ServiceCallCheckFeedbackInitial()) {
    on<FetchServiceCallCheckFeedbackEvent>(_onFetchServiceCallCheckFeedback);
  }

  Future<void> _onFetchServiceCallCheckFeedback(
    FetchServiceCallCheckFeedbackEvent event,
    Emitter<ServiceCallCheckFeedbackState> emit,
  ) async {
    emit(ServiceCallCheckFeedbackLoading());
    final result = await usecase(event.reportId);
    result.fold(
      (failure) => emit(ServiceCallCheckFeedbackError(failure.message)),
      (response) => emit(ServiceCallCheckFeedbackLoaded(response)),
    );
  }
}
