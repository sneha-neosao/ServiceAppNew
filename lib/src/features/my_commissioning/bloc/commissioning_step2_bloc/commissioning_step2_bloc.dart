import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/logger.dart';
import '../../../../remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_response.dart';
import '../../domain/usecase/commissioning_step2_usecase.dart';

part 'commissioning_step2_event.dart';
part 'commissioning_step2_state.dart';

/// Handles state management for **CommissioningStep2** and its related entities.

class CommissioningStep2Bloc extends Bloc<CommissioningStep2Event, CommissioningStep2State> {
  final CommissioningStep2Usecase _commissioningStep2Usecase;
  CommissioningStep2Bloc(
    this._commissioningStep2Usecase,
  ) : super(CommissioningStep2InitialState()) {
    on<CommissioningStep2GetEvent>(_commissioningStep1);
  }

  /// - **CommissioningStep1:** Handles [CommissioningStep2GetEvent] → calls [CommissioningStep2Usecase]
  Future _commissioningStep1(CommissioningStep2GetEvent event, Emitter emit) async {
    emit(CommissioningStep2LoadingState());

    final result = await _commissioningStep2Usecase.call(
      CommissioningStep2Params(
          id: event.id,
          warrantyPeriodYears: event.warrantyPeriodYears,
          memberPresentsCustomerSide: event.memberPresentsCustomerSide,
          agenda: event.agenda,
      )
    );

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CommissioningStep2FailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(CommissioningStep2SuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CommissioningStep2Bloc =====");
    return super.close();
  }
}
