import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/failure_converter.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step4_autofill_usecase.dart';
import 'service_work_report_step4_autofill_event.dart';
import 'service_work_report_step4_autofill_state.dart';

class ServiceWorkReportStep4AutofillBloc
    extends Bloc<ServiceWorkReportStep4AutofillEvent, ServiceWorkReportStep4AutofillState> {
  final ServiceWorkReportStep4AutoFillUsecase usecase;

  ServiceWorkReportStep4AutofillBloc(this.usecase)
      : super(ServiceWorkReportStep4AutofillInitial()) {
    on<GetServiceWorkReportStep4AutofillEvent>(_onGetServiceWorkReportStep4AutofillEvent);
  }

  Future<void> _onGetServiceWorkReportStep4AutofillEvent(
    GetServiceWorkReportStep4AutofillEvent event,
    Emitter<ServiceWorkReportStep4AutofillState> emit,
  ) async {
    emit(ServiceWorkReportStep4AutofillLoading());
    final result = await usecase(
      ServiceWorkReportStep4AutoFillParams(event.reportId),
    );
    result.fold(
      (failure) => emit(
        ServiceWorkReportStep4AutofillFailure(mapFailureToMessage(failure)),
      ),
      (data) => emit(ServiceWorkReportStep4AutofillSuccess(data)),
    );
  }
}
