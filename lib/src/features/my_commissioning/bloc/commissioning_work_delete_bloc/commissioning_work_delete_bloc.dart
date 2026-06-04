import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_delete_usecase.dart';
import 'commissioning_work_delete_event.dart';
import 'commissioning_work_delete_state.dart';

class CommissioningWorkDeleteBloc
    extends Bloc<CommissioningWorkDeleteEvent, CommissioningWorkDeleteState> {
  final CommissioningWorkDeleteUseCase _useCase;

  CommissioningWorkDeleteBloc(this._useCase)
    : super(const CommissioningWorkDeleteInitialState()) {
    on<CommissioningWorkDeleteSubmitEvent>(_onDelete);
  }

  Future<void> _onDelete(
    CommissioningWorkDeleteSubmitEvent event,
    Emitter<CommissioningWorkDeleteState> emit,
  ) async {
    emit(const CommissioningWorkDeleteLoadingState());
    final result = await _useCase.call(event.workId);
    result.fold(
      (failure) => emit(CommissioningWorkDeleteFailureState(failure.message)),
      (message) => emit(CommissioningWorkDeleteSuccessState(message)),
    );
  }
}
