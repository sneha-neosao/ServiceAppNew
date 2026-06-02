import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import 'commissioning_report_history_event.dart';
import 'commissioning_report_history_state.dart';

class CommissioningReportHistoryBloc
    extends
        Bloc<CommissioningReportHistoryEvent, CommissioningReportHistoryState> {
  final CommissioningReportHistoryUseCase _useCase;

  CommissioningReportHistoryBloc(this._useCase)
    : super(const CommissioningReportHistoryInitialState()) {
    on<CommissioningReportHistoryGetEvent>(_onGetHistory);
  }

  Future<void> _onGetHistory(
    CommissioningReportHistoryGetEvent event,
    Emitter<CommissioningReportHistoryState> emit,
  ) async {
    emit(const CommissioningReportHistoryLoadingState());
    final result = await _useCase.call(event.params);
    result.fold(
      (failure) =>
          emit(CommissioningReportHistoryFailureState(failure.message)),
      (data) => emit(CommissioningReportHistorySuccessState(data)),
    );
  }
}
