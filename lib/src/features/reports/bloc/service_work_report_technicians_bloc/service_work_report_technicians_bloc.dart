import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/failure_converter.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_technicians_usecase.dart';
import 'service_work_report_technicians_event.dart';
import 'service_work_report_technicians_state.dart';

class ServiceWorkReportTechniciansBloc
    extends
        Bloc<
          ServiceWorkReportTechniciansEvent,
          ServiceWorkReportTechniciansState
        > {
  final ServiceWorkReportTechniciansUsecase usecase;

  ServiceWorkReportTechniciansBloc(this.usecase)
    : super(ServiceWorkReportTechniciansInitial()) {
    on<FetchServiceWorkReportTechniciansEvent>(
      _onFetchServiceWorkReportTechniciansEvent,
    );
  }

  Future<void> _onFetchServiceWorkReportTechniciansEvent(
    FetchServiceWorkReportTechniciansEvent event,
    Emitter<ServiceWorkReportTechniciansState> emit,
  ) async {
    emit(ServiceWorkReportTechniciansLoading());
    final result = await usecase(
      ServiceWorkReportTechniciansParams(event.reportId),
    );
    result.fold(
      (failure) =>
          emit(ServiceWorkReportTechniciansError(mapFailureToMessage(failure))),
      (response) => emit(ServiceWorkReportTechniciansLoaded(response)),
    );
  }
}
