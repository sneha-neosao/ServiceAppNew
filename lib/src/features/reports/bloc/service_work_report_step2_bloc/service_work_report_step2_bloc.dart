import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step2_usecase.dart';
import 'service_work_report_step2_event.dart';
import 'service_work_report_step2_state.dart';

class ServiceWorkReportStep2Bloc
    extends Bloc<ServiceWorkReportStep2Event, ServiceWorkReportStep2State> {
  final ServiceWorkReportStep2Usecase usecase;

  ServiceWorkReportStep2Bloc({required this.usecase})
      : super(ServiceWorkReportStep2Initial()) {
    on<PostServiceWorkReportStep2Event>((event, emit) async {
      emit(ServiceWorkReportStep2Loading());
      final result = await usecase.call(event.params);
      result.fold(
        (failure) => emit(ServiceWorkReportStep2Failure(failure.message)),
        (data) => emit(ServiceWorkReportStep2Success(data)),
      );
    });
  }
}
