import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step4_autofill_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step4_autofill_event.dart';
import 'service_call_report_step4_autofill_state.dart';

class ServiceCallReportStep4AutoFillBloc extends Bloc<
    ServiceCallReportStep4AutoFillEvent, ServiceCallReportStep4AutoFillState> {
  final ServiceCallReportStep4AutoFillUsecase usecase;

  ServiceCallReportStep4AutoFillBloc({required this.usecase})
      : super(ServiceCallReportStep4AutoFillInitialState()) {
    on<ServiceCallReportStep4AutoFillGetEvent>(_onGetEvent);
  }

  Future<void> _onGetEvent(
    ServiceCallReportStep4AutoFillGetEvent event,
    Emitter<ServiceCallReportStep4AutoFillState> emit,
  ) async {
    emit(ServiceCallReportStep4AutoFillLoadingState());
    final result = await usecase(event.complaintId);
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep4AutoFillFailureState(failure.message)),
      (data) => emit(ServiceCallReportStep4AutoFillSuccessState(data)),
    );
  }
}
