import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/home/domain/usecase/upcoming_amc_usecase.dart';
import 'package:service_app/src/remote/models/upcoming_amc_model/upcoming_amc_response.dart';

part 'upcoming_amc_event.dart';
part 'upcoming_amc_state.dart';

/// Handles state management for **UpcomingAmc** and its related entities.

class UpcomingAmcBloc extends Bloc<UpcomingAmcEvent, UpcomingAmcState> {
  final UpcomingAmcUseCase _upcomingAmcUseCase;
  UpcomingAmcBloc(this._upcomingAmcUseCase) : super(UpcomingAmcinitialState()) {
    on<UpcomingAmcGetEvent>(_sites);
  }

  /// - **UpcomingAmc:** Handles [UpcomingAmcGetEvent] → calls [UpcomingAmcUseCase]
  Future _sites(UpcomingAmcGetEvent event, Emitter emit) async {
    emit(UpcomingAmcLoadingState());

    final result = await _upcomingAmcUseCase.call(
      UpcomingAmcParams(filter: event.filter, pending: event.pending),
    );

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(UpcomingAmcFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(UpcomingAmcSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE UpcomingAmcBloc =====");
    return super.close();
  }
}
