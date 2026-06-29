import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/amc/domain/usecase/amc_visits_list_usecase.dart';
import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_list_response.dart';

part 'amc_visits_list_event.dart';
part 'amc_visits_list_state.dart';

class AmcVisitsListBloc extends Bloc<AmcVisitsListEvent, AmcVisitsListState> {
  final AmcVisitsListUseCase _amcVisitsListUseCase;

  AmcVisitsListBloc(this._amcVisitsListUseCase)
    : super(AmcVisitsListInitialState()) {
    on<AmcVisitsListGetEvent>(_getAmcVisitsList);
  }

  Future _getAmcVisitsList(AmcVisitsListGetEvent event, Emitter emit) async {
    emit(AmcVisitsListLoadingState());
    final result = await _amcVisitsListUseCase.call(NoParams());

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(AmcVisitsListFailureState(failure.message));
    } else {
      final response = result.getRight().toNullable()!;
      emit(AmcVisitsListSuccessState(response));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AmcVisitsListBloc =====");
    return super.close();
  }
}
