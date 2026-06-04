import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import '../../../../remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_autofill_response.dart';
import '../../domain/usecase/commissioning_step2_autofill_usecase.dart';

part 'commissioning_step2_autofill_event.dart';
part 'commissioning_step2_autofill_state.dart';

/// Handles state management for **CommissioningStep2AutoFill** and its related entities.

class CommissioningStep2AutoFillBloc
    extends
        Bloc<CommissioningStep2AutoFillEvent, CommissioningStep2AutoFillState> {
  final CommissioningStep2AutofillUsecase _commissioningStep2AutofillUsecase;
  CommissioningStep2AutoFillBloc(this._commissioningStep2AutofillUsecase)
    : super(CommissioningStep2AutoFillInitialState()) {
    on<CommissioningStep2AutoFillGetEvent>(_commissioningStep2Autofill);
  }

  /// - **CommissioningStep2AutoFill:** Handles [CommissioningStep2AutoFillGetEvent] → calls [CustomerUseCase]
  Future _commissioningStep2Autofill(
    CommissioningStep2AutoFillGetEvent event,
    Emitter emit,
  ) async {
    emit(CommissioningStep2AutoFillLoadingState());

    final result = await _commissioningStep2AutofillUsecase.call(
      CommissioningStep2AutofillParams(
        commissioning_report_id: event.commissioning_report_id,
      ),
    );

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CommissioningStep2AutoFillFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(CommissioningStep2AutoFillSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CommissioningStep2AutoFillBloc =====");
    return super.close();
  }
}
