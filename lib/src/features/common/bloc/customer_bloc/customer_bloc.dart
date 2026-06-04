import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';

part 'customer_event.dart';
part 'customer_state.dart';

/// Handles state management for **Customer** and its related entities.

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerUseCase _customerUseCase;
  CustomerBloc(this._customerUseCase) : super(CustomerInitialState()) {
    on<CustomerGetEvent>(_customers);
  }

  /// - **Customer:** Handles [CustomerGetEvent] → calls [CustomerUseCase]
  Future _customers(CustomerGetEvent event, Emitter emit) async {
    emit(CustomerLoadingState());

    final result = await _customerUseCase.call(NoParams());

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CustomerFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(CustomerSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CustomerBloc =====");
    return super.close();
  }
}
