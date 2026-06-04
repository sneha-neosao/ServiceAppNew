import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_autofill_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step3_autofill_event.dart';
import 'service_call_report_step3_autofill_state.dart';

class ServiceCallReportStep3AutoFillBloc
    extends
        Bloc<
          ServiceCallReportStep3AutoFillEvent,
          ServiceCallReportStep3AutoFillState
        > {
  final ServiceCallReportStep3AutoFillUsecase usecase;

  ServiceCallReportStep3AutoFillBloc({required this.usecase})
    : super(ServiceCallReportStep3AutoFillInitialState()) {
    on<ServiceCallReportStep3AutoFillGetEvent>(_onGetEvent);
  }

  Future<void> _onGetEvent(
    ServiceCallReportStep3AutoFillGetEvent event,
    Emitter<ServiceCallReportStep3AutoFillState> emit,
  ) async {
    emit(ServiceCallReportStep3AutoFillLoadingState());
    final result = await usecase(event.complaintId);
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep3AutoFillFailureState(failure.message)),
      (data) => emit(ServiceCallReportStep3AutoFillSuccessState(data)),
    );
  }
}
