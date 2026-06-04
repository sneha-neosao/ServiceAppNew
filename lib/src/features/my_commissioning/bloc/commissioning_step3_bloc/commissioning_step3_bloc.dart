import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/commissioning_step3_usecase.dart';
import 'commissioning_step3_event.dart';
import 'commissioning_step3_state.dart';

class CommissioningStep3Bloc
    extends Bloc<CommissioningStep3Event, CommissioningStep3State> {
  final CommissioningStep3Usecase _commissioningStep3Usecase;
  CommissioningStep3Bloc(this._commissioningStep3Usecase)
    : super(CommissioningStep3InitialState()) {
    on<CommissioningStep3GetEvent>(_commissioningStep3);
  }

  Future _commissioningStep3(
    CommissioningStep3GetEvent event,
    Emitter emit,
  ) async {
    emit(CommissioningStep3LoadingState());

    final result = await _commissioningStep3Usecase.call(
      CommissioningStep3Params(
        id: event.id,
        isTechnicalNa: event.isTechnicalNa,
        technicalDetails: event.technicalDetails,
      ),
    );

    result.fold(
      (failure) => emit(
        CommissioningStep3FailureState(failure.message ?? "An error occurred"),
      ),
      (data) {
        emit(CommissioningStep3SuccessState(data));
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
