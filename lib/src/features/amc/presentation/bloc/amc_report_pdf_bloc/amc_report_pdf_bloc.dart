import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/domain/usecases/amc_report/get_amc_report_pdf_usecase.dart';

part 'amc_report_pdf_event.dart';
part 'amc_report_pdf_state.dart';

class AmcReportPdfBloc extends Bloc<AmcReportPdfEvent, AmcReportPdfState> {
  final GetAmcReportPdfUseCase getAmcReportPdfUseCase;

  AmcReportPdfBloc({required this.getAmcReportPdfUseCase}) : super(AmcReportPdfInitial()) {
    on<FetchAmcReportPdfEvent>((event, emit) async {
      emit(AmcReportPdfLoading());
      final result = await getAmcReportPdfUseCase(event.reportId);
      result.fold(
        (failure) => emit(AmcReportPdfFailure(error: failure.message)),
        (response) {
          if (response.success && response.data != null && response.data!.pdfUrl.isNotEmpty) {
            emit(AmcReportPdfSuccess(pdfUrl: response.data!.pdfUrl, message: response.message));
          } else {
            emit(AmcReportPdfFailure(error: response.message.isNotEmpty ? response.message : "Failed to load PDF"));
          }
        },
      );
    });
  }
}
