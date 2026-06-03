import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_autofill_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step1_autofill_event.dart';
import 'service_call_report_step1_autofill_state.dart';

class ServiceCallReportStep1AutoFillBloc extends Bloc<
    ServiceCallReportStep1AutoFillEvent, ServiceCallReportStep1AutoFillState> {
  final ServiceCallReportStep1AutoFillUsecase usecase;

  ServiceCallReportStep1AutoFillBloc({required this.usecase})
      : super(ServiceCallReportStep1AutoFillInitialState()) {
    on<ServiceCallReportStep1AutoFillGetEvent>(_onGetEvent);
  }

  Future<void> _onGetEvent(
    ServiceCallReportStep1AutoFillGetEvent event,
    Emitter<ServiceCallReportStep1AutoFillState> emit,
  ) async {
    emit(ServiceCallReportStep1AutoFillLoadingState());
    final result = await usecase(event.complaintId);
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep1AutoFillFailureState(failure.message)),
      (data) => emit(ServiceCallReportStep1AutoFillSuccessState(data)),
    );
  }
}
