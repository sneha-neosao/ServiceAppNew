import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step5_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step5_event.dart';
import 'service_call_report_step5_state.dart';

class ServiceCallReportStep5Bloc
    extends Bloc<ServiceCallReportStep5Event, ServiceCallReportStep5State> {
  final ServiceCallReportStep5Usecase usecase;

  ServiceCallReportStep5Bloc({required this.usecase})
      : super(ServiceCallReportStep5InitialState()) {
    on<ServiceCallReportStep5PostEvent>(_onPostEvent);
  }

  Future<void> _onPostEvent(
    ServiceCallReportStep5PostEvent event,
    Emitter<ServiceCallReportStep5State> emit,
  ) async {
    emit(ServiceCallReportStep5LoadingState());
    final result = await usecase(ServiceCallReportStep5Params(
      reportId: event.reportId,
      isMechanicalChecklistNa: event.isMechanicalChecklistNa,
      isPipelineChecklistNa: event.isPipelineChecklistNa,
      isElectricalChecklistNa: event.isElectricalChecklistNa,
      checklistItems: event.checklistItems,
    ));
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep5FailureState(failure.message)),
      (data) => emit(ServiceCallReportStep5SuccessState(data)),
    );
  }
}
