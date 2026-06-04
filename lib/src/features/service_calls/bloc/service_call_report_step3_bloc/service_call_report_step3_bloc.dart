import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step3_event.dart';
import 'service_call_report_step3_state.dart';

class ServiceCallReportStep3Bloc
    extends Bloc<ServiceCallReportStep3Event, ServiceCallReportStep3State> {
  final ServiceCallReportStep3Usecase usecase;

  ServiceCallReportStep3Bloc({required this.usecase})
    : super(ServiceCallReportStep3InitialState()) {
    on<ServiceCallReportStep3PostEvent>(_onPostEvent);
  }

  Future<void> _onPostEvent(
    ServiceCallReportStep3PostEvent event,
    Emitter<ServiceCallReportStep3State> emit,
  ) async {
    emit(ServiceCallReportStep3LoadingState());
    final result = await usecase(event.params);
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep3FailureState(failure.message)),
      (data) => emit(ServiceCallReportStep3SuccessState(data)),
    );
  }
}
