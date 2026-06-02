import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_create_usecase.dart';
import 'package:service_app/src/remote/models/commissioning_work_create_model/commissioning_work_create_response.dart';

part 'commissioning_work_create_event.dart';
part 'commissioning_work_create_state.dart';

class CommissioningWorkCreateBloc
    extends Bloc<CommissioningWorkCreateEvent, CommissioningWorkCreateState> {
  final CommissioningWorkCreateUseCase _commissioningWorkCreateUseCase;

  CommissioningWorkCreateBloc(this._commissioningWorkCreateUseCase)
      : super(CommissioningWorkCreateInitialState()) {
    on<CommissioningWorkCreateSubmitEvent>(_onCreateSubmit);
  }

  Future<void> _onCreateSubmit(
    CommissioningWorkCreateSubmitEvent event,
    Emitter<CommissioningWorkCreateState> emit,
  ) async {
    emit(CommissioningWorkCreateLoadingState());

    final result = await _commissioningWorkCreateUseCase.call(
      CommissioningWorkCreateParams(
        customerId: event.customerId,
        siteId: event.siteId,
        applicationOfEquipment: event.applicationOfEquipment,
        technicians: event.technicians,
      ),
    );

    result.fold(
      (failure) => emit(CommissioningWorkCreateFailureState(failure.message)),
      (data) => emit(CommissioningWorkCreateSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CommissioningWorkCreateBloc =====");
    return super.close();
  }
}
