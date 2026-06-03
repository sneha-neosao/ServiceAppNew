import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step2_event.dart';
import 'service_call_report_step2_state.dart';

class ServiceCallReportStep2Bloc extends Bloc<
    ServiceCallReportStep2Event, ServiceCallReportStep2State> {
  final ServiceCallReportStep2Usecase usecase;

  ServiceCallReportStep2Bloc({required this.usecase})
      : super(ServiceCallReportStep2InitialState()) {
    on<ServiceCallReportStep2PostEvent>(_onPostEvent);
  }

  Future<void> _onPostEvent(
    ServiceCallReportStep2PostEvent event,
    Emitter<ServiceCallReportStep2State> emit,
  ) async {
    emit(ServiceCallReportStep2LoadingState());
    final result = await usecase(event.params);
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep2FailureState(failure.message)),
      (data) => emit(ServiceCallReportStep2SuccessState(data)),
    );
  }
}
