import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step2_autofill_usecase.dart';
import 'service_work_report_step2_autofill_event.dart';
import 'service_work_report_step2_autofill_state.dart';

class ServiceWorkReportStep2AutofillBloc extends Bloc<
    ServiceWorkReportStep2AutofillEvent, ServiceWorkReportStep2AutofillState> {
  final ServiceWorkReportStep2AutoFillUsecase usecase;

  ServiceWorkReportStep2AutofillBloc(this.usecase)
      : super(ServiceWorkReportStep2AutofillInitial()) {
    on<GetServiceWorkReportStep2AutofillEvent>((event, emit) async {
      emit(ServiceWorkReportStep2AutofillLoading());
      final result = await usecase(event.reportId);
      result.fold(
        (failure) =>
            emit(ServiceWorkReportStep2AutofillFailure(failure.message)),
        (data) => emit(ServiceWorkReportStep2AutofillSuccess(data)),
      );
    });
  }
}
