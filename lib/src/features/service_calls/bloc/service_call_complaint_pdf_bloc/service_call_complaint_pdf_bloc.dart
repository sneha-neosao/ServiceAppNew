import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_complaint_pdf_usecase.dart';
import 'service_call_complaint_pdf_event.dart';
import 'service_call_complaint_pdf_state.dart';

class ServiceCallComplaintPdfBloc
    extends Bloc<ServiceCallComplaintPdfEvent, ServiceCallComplaintPdfState> {
  final ServiceCallComplaintPdfUseCase usecase;

  ServiceCallComplaintPdfBloc({required this.usecase})
    : super(ServiceCallComplaintPdfInitial()) {
    on<FetchServiceCallComplaintPdfEvent>(_onFetchServiceCallComplaintPdf);
  }

  Future<void> _onFetchServiceCallComplaintPdf(
    FetchServiceCallComplaintPdfEvent event,
    Emitter<ServiceCallComplaintPdfState> emit,
  ) async {
    emit(ServiceCallComplaintPdfLoading());
    final result = await usecase(event.complaintId);
    result.fold(
      (failure) => emit(ServiceCallComplaintPdfError(failure.message)),
      (response) => emit(ServiceCallComplaintPdfLoaded(response, event.action)),
    );
  }
}
