import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_pdf_usecase.dart';
import 'commissioning_report_pdf_event.dart';
import 'commissioning_report_pdf_state.dart';

class CommissioningReportPdfBloc
    extends Bloc<CommissioningReportPdfEvent, CommissioningReportPdfState> {
  final CommissioningReportPdfUseCase usecase;

  CommissioningReportPdfBloc({required this.usecase})
    : super(CommissioningReportPdfInitial()) {
    on<FetchCommissioningReportPdfEvent>(_onFetchCommissioningReportPdf);
  }

  Future<void> _onFetchCommissioningReportPdf(
    FetchCommissioningReportPdfEvent event,
    Emitter<CommissioningReportPdfState> emit,
  ) async {
    emit(CommissioningReportPdfLoading());
    final result = await usecase(event.reportId);
    result.fold(
      (failure) => emit(CommissioningReportPdfError(failure.message)),
      (response) => emit(CommissioningReportPdfLoaded(response, event.action)),
    );
  }
}
