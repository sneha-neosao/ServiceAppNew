import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_autofill_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step2_autofill_event.dart';
import 'service_call_report_step2_autofill_state.dart';

class ServiceCallReportStep2AutoFillBloc
    extends
        Bloc<
          ServiceCallReportStep2AutoFillEvent,
          ServiceCallReportStep2AutoFillState
        > {
  final ServiceCallReportStep2AutoFillUsecase usecase;

  ServiceCallReportStep2AutoFillBloc({required this.usecase})
    : super(ServiceCallReportStep2AutoFillInitialState()) {
    on<ServiceCallReportStep2AutoFillGetEvent>(_onGetEvent);
  }

  Future<void> _onGetEvent(
    ServiceCallReportStep2AutoFillGetEvent event,
    Emitter<ServiceCallReportStep2AutoFillState> emit,
  ) async {
    emit(ServiceCallReportStep2AutoFillLoadingState());
    final result = await usecase(event.complaintId);
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep2AutoFillFailureState(failure.message)),
      (data) => emit(ServiceCallReportStep2AutoFillSuccessState(data)),
    );
  }
}
