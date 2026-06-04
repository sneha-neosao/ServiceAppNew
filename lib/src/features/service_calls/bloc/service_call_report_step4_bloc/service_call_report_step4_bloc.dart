import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step4_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step4_event.dart';
import 'service_call_report_step4_state.dart';

class ServiceCallReportStep4Bloc
    extends Bloc<ServiceCallReportStep4Event, ServiceCallReportStep4State> {
  final ServiceCallReportStep4Usecase usecase;

  ServiceCallReportStep4Bloc({required this.usecase})
    : super(ServiceCallReportStep4InitialState()) {
    on<ServiceCallReportStep4PostEvent>(_onPostEvent);
  }

  Future<void> _onPostEvent(
    ServiceCallReportStep4PostEvent event,
    Emitter<ServiceCallReportStep4State> emit,
  ) async {
    emit(ServiceCallReportStep4LoadingState());
    final result = await usecase(
      ServiceCallReportStep4Params(
        reportId: event.reportId,
        descriptions: event.descriptions,
      ),
    );
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep4FailureState(failure.message)),
      (data) => emit(ServiceCallReportStep4SuccessState(data)),
    );
  }
}
