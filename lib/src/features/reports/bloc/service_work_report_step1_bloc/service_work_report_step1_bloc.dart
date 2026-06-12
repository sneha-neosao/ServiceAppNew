import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step1_usecase.dart';
import 'service_work_report_step1_event.dart';
import 'service_work_report_step1_state.dart';

class ServiceWorkReportStep1Bloc extends Bloc<ServiceWorkReportStep1Event, ServiceWorkReportStep1State> {
  final ServiceWorkReportStep1Usecase usecase;

  ServiceWorkReportStep1Bloc({required this.usecase}) : super(ServiceWorkReportStep1Initial()) {
    on<PostServiceWorkReportStep1Event>(_onPostStep1);
  }

  Future<void> _onPostStep1(
    PostServiceWorkReportStep1Event event,
    Emitter<ServiceWorkReportStep1State> emit,
  ) async {
    emit(ServiceWorkReportStep1Loading());
    final result = await usecase(event.params);
    result.fold(
      (failure) => emit(ServiceWorkReportStep1Failure(failure.message)),
      (data) => emit(ServiceWorkReportStep1Success(data)),
    );
  }
}
