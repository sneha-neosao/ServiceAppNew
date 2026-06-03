import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assign_technician_service_calls_bloc/assign_technician_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/assign_technician_service_calls_bloc/assign_technician_service_calls_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';

class AssignTechnicianServiceCallsBloc extends Bloc<
    AssignTechnicianServiceCallsEvent, AssignTechnicianServiceCallsState> {
  final AssignTechnicianServiceCallsUsecase assignTechnicianServiceCallsUsecase;

  AssignTechnicianServiceCallsBloc({
    required this.assignTechnicianServiceCallsUsecase,
  }) : super(AssignTechnicianServiceCallsInitialState()) {
    on<AssignTechnicianServiceCallsPostEvent>(_onPostAssignTechnician);
  }

  Future<void> _onPostAssignTechnician(
    AssignTechnicianServiceCallsPostEvent event,
    Emitter<AssignTechnicianServiceCallsState> emit,
  ) async {
    emit(AssignTechnicianServiceCallsLoadingState());

    final result = await assignTechnicianServiceCallsUsecase(event.params);

    result.fold(
      (failure) =>
          emit(AssignTechnicianServiceCallsFailureState(failure.message)),
      (data) => emit(AssignTechnicianServiceCallsSuccessState(data)),
    );
  }
}
