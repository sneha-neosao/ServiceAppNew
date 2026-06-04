import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_bloc/service_call_report_step1_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_bloc/service_call_report_step1_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';

class ServiceCallReportStep1Bloc
    extends Bloc<ServiceCallReportStep1Event, ServiceCallReportStep1State> {
  final ServiceCallReportStep1Usecase usecase;

  ServiceCallReportStep1Bloc({required this.usecase})
    : super(ServiceCallReportStep1InitialState()) {
    on<ServiceCallReportStep1PostEvent>(_onPostStep1);
  }

  Future<void> _onPostStep1(
    ServiceCallReportStep1PostEvent event,
    Emitter<ServiceCallReportStep1State> emit,
  ) async {
    emit(ServiceCallReportStep1LoadingState());

    final result = await usecase(event.params);

    result.fold(
      (failure) => emit(ServiceCallReportStep1FailureState(failure.message)),
      (data) => emit(ServiceCallReportStep1SuccessState(data)),
    );
  }
}
