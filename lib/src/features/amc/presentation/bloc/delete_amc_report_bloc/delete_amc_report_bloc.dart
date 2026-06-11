import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../domain/usecases/amc_report/delete_amc_report_usecase.dart';
import 'delete_amc_report_event.dart';
import 'delete_amc_report_state.dart';

class DeleteAmcReportBloc
    extends Bloc<DeleteAmcReportEvent, DeleteAmcReportState> {
  final DeleteAmcReportUsecase _deleteAmcReportUsecase;

  DeleteAmcReportBloc(this._deleteAmcReportUsecase)
      : super(DeleteAmcReportInitialState()) {
    on<DeleteAmcReportSubmitEvent>((event, emit) async {
      emit(DeleteAmcReportLoadingState());

      final result = await _deleteAmcReportUsecase.call(event.reportId);
      result.fold(
        (failure) => emit(DeleteAmcReportFailureState(failure.message)),
        (data) => emit(DeleteAmcReportSuccessState(data)),
      );
    });
  }
}
