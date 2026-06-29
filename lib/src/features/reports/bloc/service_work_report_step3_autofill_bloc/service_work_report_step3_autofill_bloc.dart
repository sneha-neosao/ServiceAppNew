import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step3_autofill_usecase.dart';
import 'service_work_report_step3_autofill_event.dart';
import 'service_work_report_step3_autofill_state.dart';

class ServiceWorkReportStep3AutofillBloc
    extends
        Bloc<
          ServiceWorkReportStep3AutofillEvent,
          ServiceWorkReportStep3AutofillState
        > {
  final ServiceWorkReportStep3AutoFillUsecase usecase;

  ServiceWorkReportStep3AutofillBloc(this.usecase)
    : super(ServiceWorkReportStep3AutofillInitial()) {
    on<GetServiceWorkReportStep3AutofillEvent>((event, emit) async {
      emit(ServiceWorkReportStep3AutofillLoading());
      final result = await usecase.call(event.reportId);
      result.fold(
        (failure) =>
            emit(ServiceWorkReportStep3AutofillFailure(failure.message)),
        (data) => emit(ServiceWorkReportStep3AutofillSuccess(data)),
      );
    });
  }
}
