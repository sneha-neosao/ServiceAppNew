import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step5_autofill_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step5_autofill_event.dart';
import 'service_call_report_step5_autofill_state.dart';

class ServiceCallReportStep5AutoFillBloc
    extends Bloc<ServiceCallReportStep5AutoFillEvent, ServiceCallReportStep5AutoFillState> {
  final ServiceCallReportStep5AutoFillUsecase usecase;

  ServiceCallReportStep5AutoFillBloc({required this.usecase})
      : super(ServiceCallReportStep5AutoFillInitialState()) {
    on<ServiceCallReportStep5AutoFillGetEvent>(_onGetEvent);
  }

  Future<void> _onGetEvent(
    ServiceCallReportStep5AutoFillGetEvent event,
    Emitter<ServiceCallReportStep5AutoFillState> emit,
  ) async {
    emit(ServiceCallReportStep5AutoFillLoadingState());
    final result = await usecase(ServiceCallReportStep5AutoFillParams(event.reportId));
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep5AutoFillFailureState(failure.message)),
      (data) => emit(ServiceCallReportStep5AutoFillSuccessState(data)),
    );
  }
}
