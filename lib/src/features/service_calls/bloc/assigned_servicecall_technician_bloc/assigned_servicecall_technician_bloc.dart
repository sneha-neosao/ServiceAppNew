import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assigned_servicecall_technician_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'assigned_servicecall_technician_event.dart';
import 'assigned_servicecall_technician_state.dart';

class AssignedServicecallTechnicianBloc
    extends
        Bloc<
          AssignedServicecallTechnicianEvent,
          AssignedServicecallTechnicianState
        > {
  final AssignedServicecallTechnicianUsecase usecase;

  AssignedServicecallTechnicianBloc({required this.usecase})
    : super(AssignedServicecallTechnicianInitialState()) {
    on<AssignedServicecallTechnicianGetEvent>(_onGetEvent);
  }

  Future<void> _onGetEvent(
    AssignedServicecallTechnicianGetEvent event,
    Emitter<AssignedServicecallTechnicianState> emit,
  ) async {
    emit(AssignedServicecallTechnicianLoadingState());
    final result = await usecase(
      AssignedServicecallTechnicianParams(event.reportId),
    );
    result.fold(
      (Failure failure) =>
          emit(AssignedServicecallTechnicianFailureState(failure.message)),
      (data) => emit(AssignedServicecallTechnicianSuccessState(data)),
    );
  }
}
