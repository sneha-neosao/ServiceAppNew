import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_update_usecase.dart';
import 'commissioning_work_update_event.dart';
import 'commissioning_work_update_state.dart';

class CommissioningWorkUpdateBloc
    extends Bloc<CommissioningWorkUpdateEvent, CommissioningWorkUpdateState> {
  final CommissioningWorkUpdateUseCase _useCase;

  CommissioningWorkUpdateBloc(this._useCase)
      : super(const CommissioningWorkUpdateInitialState()) {
    on<CommissioningWorkUpdateSubmitEvent>(_onUpdate);
  }

  Future<void> _onUpdate(
    CommissioningWorkUpdateSubmitEvent event,
    Emitter<CommissioningWorkUpdateState> emit,
  ) async {
    emit(const CommissioningWorkUpdateLoadingState());
    final result = await _useCase.call(
      CommissioningWorkUpdateParams(
        customerId: event.customerId,
        siteId: event.siteId,
        applicationOfEquipment: event.applicationOfEquipment,
        technicians: event.technicians,
      ),
      event.workId,
    );
    result.fold(
      (failure) => emit(CommissioningWorkUpdateFailureState(failure.message)),
      (data) => emit(CommissioningWorkUpdateSuccessState(data)),
    );
  }
}
