import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_details_usecase.dart';
import 'commissioning_report_details_event.dart';
import 'commissioning_report_details_state.dart';

class CommissioningReportDetailsBloc extends Bloc<
    CommissioningReportDetailsEvent, CommissioningReportDetailsState> {
  final CommissioningReportDetailsUseCase _useCase;

  CommissioningReportDetailsBloc(this._useCase)
      : super(const CommissioningReportDetailsInitialState()) {
    on<CommissioningReportDetailsGetEvent>(_onGetDetails);
  }

  Future<void> _onGetDetails(
    CommissioningReportDetailsGetEvent event,
    Emitter<CommissioningReportDetailsState> emit,
  ) async {
    emit(const CommissioningReportDetailsLoadingState());
    final result = await _useCase.call(event.reportId);
    result.fold(
      (failure) =>
          emit(CommissioningReportDetailsFailureState(failure.message)),
      (data) => emit(CommissioningReportDetailsSuccessState(data)),
    );
  }
}
