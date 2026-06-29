import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step3_usecase.dart';
import 'service_work_report_step3_event.dart';
import 'service_work_report_step3_state.dart';

class ServiceWorkReportStep3Bloc
    extends Bloc<ServiceWorkReportStep3Event, ServiceWorkReportStep3State> {
  final ServiceWorkReportStep3Usecase usecase;

  ServiceWorkReportStep3Bloc({required this.usecase})
    : super(ServiceWorkReportStep3Initial()) {
    on<PostServiceWorkReportStep3Event>((event, emit) async {
      emit(ServiceWorkReportStep3Loading());
      final result = await usecase.call(event.params);
      result.fold(
        (failure) => emit(ServiceWorkReportStep3Failure(failure.message)),
        (data) => emit(ServiceWorkReportStep3Success(data)),
      );
    });
  }
}
