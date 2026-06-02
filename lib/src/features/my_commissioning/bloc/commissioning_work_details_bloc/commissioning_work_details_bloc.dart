import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_details_usecase.dart';
import 'commissioning_work_details_event.dart';
import 'commissioning_work_details_state.dart';

class CommissioningWorkDetailsBloc
    extends Bloc<CommissioningWorkDetailsEvent, CommissioningWorkDetailsState> {
  final CommissioningWorkDetailsUseCase _useCase;

  CommissioningWorkDetailsBloc(this._useCase)
      : super(const CommissioningWorkDetailsInitialState()) {
    on<CommissioningWorkDetailsGetEvent>(_onGetDetails);
  }

  Future<void> _onGetDetails(
    CommissioningWorkDetailsGetEvent event,
    Emitter<CommissioningWorkDetailsState> emit,
  ) async {
    emit(const CommissioningWorkDetailsLoadingState());
    final result = await _useCase.call(event.workId);
    result.fold(
      (failure) => emit(CommissioningWorkDetailsFailureState(failure.message)),
      (data) => emit(CommissioningWorkDetailsSuccessState(data)),
    );
  }
}
