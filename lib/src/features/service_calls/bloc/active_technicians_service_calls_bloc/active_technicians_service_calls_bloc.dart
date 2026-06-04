import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/active_technicians_service_calls_usecase.dart';

class ActiveTechniciansServiceCallsBloc
    extends
        Bloc<
          ActiveTechniciansServiceCallsEvent,
          ActiveTechniciansServiceCallsState
        > {
  final ActiveTechniciansServiceCallsUsecase
  activeTechniciansServiceCallsUsecase;

  ActiveTechniciansServiceCallsBloc({
    required this.activeTechniciansServiceCallsUsecase,
  }) : super(ActiveTechniciansServiceCallsInitialState()) {
    on<ActiveTechniciansServiceCallsGetEvent>(_onGetActiveTechnicians);
  }

  Future<void> _onGetActiveTechnicians(
    ActiveTechniciansServiceCallsGetEvent event,
    Emitter<ActiveTechniciansServiceCallsState> emit,
  ) async {
    emit(ActiveTechniciansServiceCallsLoadingState());

    final result = await activeTechniciansServiceCallsUsecase(NoParams());

    result.fold(
      (failure) =>
          emit(ActiveTechniciansServiceCallsFailureState(failure.message)),
      (data) => emit(ActiveTechniciansServiceCallsSuccessState(data)),
    );
  }
}
