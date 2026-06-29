import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step1_autofill_usecase.dart';
import 'service_work_report_step1_autofill_event.dart';
import 'service_work_report_step1_autofill_state.dart';

class ServiceWorkReportStep1AutofillBloc
    extends
        Bloc<
          ServiceWorkReportStep1AutofillEvent,
          ServiceWorkReportStep1AutofillState
        > {
  final ServiceWorkReportStep1AutoFillUsecase usecase;

  ServiceWorkReportStep1AutofillBloc(this.usecase)
    : super(ServiceWorkReportStep1AutofillInitial()) {
    on<GetServiceWorkReportStep1AutofillEvent>((event, emit) async {
      emit(ServiceWorkReportStep1AutofillLoading());
      final result = await usecase(event.complaintId);
      result.fold(
        (failure) =>
            emit(ServiceWorkReportStep1AutofillFailure(failure.message)),
        (data) => emit(ServiceWorkReportStep1AutofillSuccess(data)),
      );
    });
  }
}
