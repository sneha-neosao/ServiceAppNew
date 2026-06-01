import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_step1_usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step1_model/commissioning_report_step1_response.dart';

part 'commissioning_step1_event.dart';
part 'commissioning_step1_state.dart';

/// Handles state management for **CommissioningStep1** and its related entities.

class CommissioningStep1Bloc extends Bloc<CommissioningStep1Event, CommissioningStep1State> {
  final CommissioningStep1Usecase _commissioningStep1Usecase;
  CommissioningStep1Bloc(
    this._commissioningStep1Usecase,
  ) : super(CommissioningStep1InitialState()) {
    on<CommissioningStep1GetEvent>(_commissioningStep1);
  }

  /// - **CommissioningStep1AutoFill:** Handles [CommissioningStep1GetEvent] → calls [CommissioningStep1Usecase]
  Future _commissioningStep1(CommissioningStep1GetEvent event, Emitter emit) async {
    emit(CommissioningStep1LoadingState());

    final result = await _commissioningStep1Usecase.call(
      CommissioningStep1Params(
          commissioningWorkId: event.commissioning_report_id,
          technicianIds: event.technicianIds
      )
    );

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CommissioningStep1FailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(CommissioningStep1lSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CommissioningStep1Bloc =====");
    return super.close();
  }
}
