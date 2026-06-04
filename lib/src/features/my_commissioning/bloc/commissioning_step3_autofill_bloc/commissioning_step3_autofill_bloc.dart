import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/commissioning_step3_autofill_usecase.dart';
import 'commissioning_step3_autofill_event.dart';
import 'commissioning_step3_autofill_state.dart';

class CommissioningStep3AutoFillBloc
    extends
        Bloc<CommissioningStep3AutoFillEvent, CommissioningStep3AutoFillState> {
  final CommissioningStep3AutofillUsecase _commissioningStep3AutofillUsecase;
  CommissioningStep3AutoFillBloc(this._commissioningStep3AutofillUsecase)
    : super(CommissioningStep3AutoFillInitialState()) {
    on<CommissioningStep3AutoFillGetEvent>(_commissioningStep3Autofill);
  }

  Future _commissioningStep3Autofill(
    CommissioningStep3AutoFillGetEvent event,
    Emitter emit,
  ) async {
    emit(CommissioningStep3AutoFillLoadingState());

    final result = await _commissioningStep3AutofillUsecase.call(
      CommissioningStep3AutofillParams(event.commissioning_report_id),
    );

    result.fold(
      (failure) => emit(
        CommissioningStep3AutoFillFailureState(
          failure.message ?? "An error occurred",
        ),
      ),
      (data) {
        emit(CommissioningStep3AutoFillSuccessState(data));
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
