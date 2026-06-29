import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_pdf_usecase.dart';
import 'service_call_report_pdf_event.dart';
import 'service_call_report_pdf_state.dart';

class ServiceCallReportPdfBloc
    extends Bloc<ServiceCallReportPdfEvent, ServiceCallReportPdfState> {
  final ServiceCallReportPdfUseCase usecase;

  ServiceCallReportPdfBloc({required this.usecase})
    : super(ServiceCallReportPdfInitial()) {
    on<FetchServiceCallReportPdfEvent>(_onFetchServiceCallReportPdf);
  }

  Future<void> _onFetchServiceCallReportPdf(
    FetchServiceCallReportPdfEvent event,
    Emitter<ServiceCallReportPdfState> emit,
  ) async {
    emit(ServiceCallReportPdfLoading());
    final result = await usecase(event.reportId);
    result.fold(
      (failure) => emit(ServiceCallReportPdfError(failure.message)),
      (response) => emit(ServiceCallReportPdfLoaded(response, event.action)),
    );
  }
}
