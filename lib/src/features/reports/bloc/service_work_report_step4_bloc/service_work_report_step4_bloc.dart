import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step4_usecase.dart';
import 'service_work_report_step4_event.dart';
import 'service_work_report_step4_state.dart';

class ServiceWorkReportStep4Bloc
    extends Bloc<ServiceWorkReportStep4Event, ServiceWorkReportStep4State> {
  final ServiceWorkReportStep4Usecase usecase;

  ServiceWorkReportStep4Bloc({required this.usecase})
      : super(ServiceWorkReportStep4Initial()) {
    on<PostServiceWorkReportStep4Event>((event, emit) async {
      emit(ServiceWorkReportStep4Loading());
      final result = await usecase(event.params);
      result.fold(
        (failure) {
          emit(ServiceWorkReportStep4Error(message: failure.message));
        },
        (response) {
          if (response.status == 200) {
            emit(ServiceWorkReportStep4Loaded(response: response));
          } else {
            emit(ServiceWorkReportStep4Error(
                message: response.message ?? 'Unknown error occurred'));
          }
        },
      );
    });
  }
}
