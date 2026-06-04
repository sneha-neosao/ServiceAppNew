import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_work_usecase.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_list_response.dart';

part 'commissioning_work_list_event.dart';
part 'commissioning_work_list_state.dart';

/// Handles state management for **CommissioningWorkList** and its related entities.

class CommissioningWorkListBloc
    extends Bloc<CommissioningWorkListEvent, CommissioningWorkListState> {
  final CommissioningWorkListUseCase _commissioningWorkListUseCase;
  CommissioningWorkListBloc(this._commissioningWorkListUseCase)
    : super(CommissioningWorkListInitialState()) {
    on<CommissioningWorkListGetEvent>(_customers);
  }

  /// - **CommissioningWorkList:** Handles [CommissioningWorkListGetEvent] → calls [CustomerUseCase]
  Future _customers(CommissioningWorkListGetEvent event, Emitter emit) async {
    emit(CommissioningWorkListLoadingState());

    final result = await _commissioningWorkListUseCase.call(NoParams());

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CommissioningWorkListFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(CommissioningWorkListSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CommissioningWorkListBloc =====");
    return super.close();
  }
}
