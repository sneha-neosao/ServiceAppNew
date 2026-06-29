import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/amc/domain/usecase/amc_visit_reports_usecase.dart';
import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_reports_response.dart';

part 'amc_visit_reports_event.dart';
part 'amc_visit_reports_state.dart';

class AmcVisitReportsBloc
    extends Bloc<AmcVisitReportsEvent, AmcVisitReportsState> {
  final AmcVisitReportsUsecase amcVisitReportsUsecase;

  AmcVisitReportsBloc(this.amcVisitReportsUsecase)
    : super(AmcVisitReportsInitialState()) {
    on<AmcVisitReportsGetEvent>(_onGetAmcVisitReports);
  }

  Future<void> _onGetAmcVisitReports(
    AmcVisitReportsGetEvent event,
    Emitter<AmcVisitReportsState> emit,
  ) async {
    emit(AmcVisitReportsLoadingState());
    final result = await amcVisitReportsUsecase(event.visitId);

    result.fold(
      (failure) =>
          emit(AmcVisitReportsFailureState(errorMessage: failure.message)),
      (data) => emit(AmcVisitReportsSuccessState(data: data)),
    );
  }
}
