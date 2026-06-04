import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_autofill_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_usecase.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_list_response.dart';

import '../../../../remote/models/commissioning_report_step1_model/commissioning_report_step1_autofill_response.dart';

part 'commissioning_step1_autofill_event.dart';
part 'commissioning_step1_autofill_state.dart';

/// Handles state management for **CommissioningStep1AutoFill** and its related entities.

class CommissioningStep1AutoFillBloc
    extends
        Bloc<CommissioningStep1AutoFillEvent, CommissioningStep1AutoFillState> {
  final CommissioningStep1AutofillUsecase _commissioningStep1AutofillUsecase;
  CommissioningStep1AutoFillBloc(this._commissioningStep1AutofillUsecase)
    : super(CommissioningStep1AutoFillInitialState()) {
    on<CommissioningStep1AutoFillGetEvent>(_commissioningStep1Autofill);
  }

  /// - **CommissioningStep1AutoFill:** Handles [CommissioningStep1AutoFillGetEvent] → calls [CustomerUseCase]
  Future _commissioningStep1Autofill(
    CommissioningStep1AutoFillGetEvent event,
    Emitter emit,
  ) async {
    emit(CommissioningStep1AutoFillLoadingState());

    final result = await _commissioningStep1AutofillUsecase.call(
      CommissioningStep1AutofillParams(
        commissioning_report_id: event.commissioning_report_id,
      ),
    );

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CommissioningStep1AutoFillFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(CommissioningStep1AutoFillSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CommissioningStep1AutoFillBloc =====");
    return super.close();
  }
}
