import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_history_usecase.dart';
import 'service_call_report_history_event.dart';
import 'service_call_report_history_state.dart';

class ServiceCallReportHistoryBloc extends Bloc<ServiceCallReportHistoryEvent, ServiceCallReportHistoryState> {
  final ServiceCallReportHistoryUsecase usecase;

  ServiceCallReportHistoryBloc({required this.usecase}) : super(ServiceCallReportHistoryInitial()) {
    on<FetchServiceCallReportHistory>((event, emit) async {
      emit(ServiceCallReportHistoryLoading());
      final result = await usecase(ServiceCallReportHistoryParams(
        customerId: event.customerId,
        siteId: event.siteId,
        date: event.date,
        startDate: event.startDate,
        endDate: event.endDate,
        page: event.page,
        pageSize: event.pageSize,
        search: event.search,
        reportType: event.reportType,
      ));
      result.fold(
        (failure) => emit(ServiceCallReportHistoryError(message: failure.message)),
        (response) {
          if (response.success) {
            emit(ServiceCallReportHistoryLoaded(response: response));
          } else {
            emit(ServiceCallReportHistoryError(message: response.message));
          }
        },
      );
    });
  }
}
