import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/reports/domain/usecases/delete_service_work_report_usecase.dart';

import 'delete_service_work_report_event.dart';
import 'delete_service_work_report_state.dart';

class DeleteServiceWorkReportBloc
    extends Bloc<DeleteServiceWorkReportEvent, DeleteServiceWorkReportState> {
  final DeleteServiceWorkReportUsecase usecase;

  DeleteServiceWorkReportBloc({required this.usecase})
    : super(DeleteServiceWorkReportInitial()) {
    on<DeleteDraftServiceWorkReportEvent>(_onDeleteReport);
  }

  Future<void> _onDeleteReport(
    DeleteDraftServiceWorkReportEvent event,
    Emitter<DeleteServiceWorkReportState> emit,
  ) async {
    emit(DeleteServiceWorkReportLoading());
    final result = await usecase(event.reportId);
    result.fold(
      (failure) => emit(DeleteServiceWorkReportFailure(failure.message)),
      (data) => emit(DeleteServiceWorkReportSuccess(data)),
    );
  }
}
