import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_reports_history_usecase.dart';
import 'amc_reports_history_event.dart';
import 'amc_reports_history_state.dart';

class AmcReportsHistoryBloc extends Bloc<AmcReportsHistoryEvent, AmcReportsHistoryState> {
  final GetAmcReportsHistoryUseCase getAmcReportsHistoryUseCase;

  AmcReportsHistoryBloc(this.getAmcReportsHistoryUseCase) : super(AmcReportsHistoryInitial()) {
    on<GetAmcReportsHistoryEvent>((event, emit) async {
      emit(AmcReportsHistoryLoadingState());
      final result = await getAmcReportsHistoryUseCase.call(
        AmcReportsHistoryParams(
          customerName: event.customerName,
          siteName: event.siteName,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
        ),
      );
      result.fold(
        (failure) => emit(AmcReportsHistoryErrorState(failure.message)),
        (data) => emit(AmcReportsHistorySuccessState(data)),
      );
    });
  }
}
