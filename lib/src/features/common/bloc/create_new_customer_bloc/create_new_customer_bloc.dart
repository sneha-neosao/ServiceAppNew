import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/failure_converter.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_customer_usecase.dart';

import 'create_new_customer_event.dart';
import 'create_new_customer_state.dart';

class CreateNewCustomerBloc
    extends Bloc<CreateNewCustomerEvent, CreateNewCustomerState> {
  final CreateNewCustomerUsecase _createNewCustomerUsecase;

  CreateNewCustomerBloc(this._createNewCustomerUsecase)
    : super(CreateNewCustomerInitialState()) {
    on<CreateNewCustomerSubmitEvent>(_onCreateNewCustomerSubmitEvent);
  }

  void _onCreateNewCustomerSubmitEvent(
    CreateNewCustomerSubmitEvent event,
    Emitter<CreateNewCustomerState> emit,
  ) async {
    emit(CreateNewCustomerLoadingState());

    final result = await _createNewCustomerUsecase(event.params);

    result.fold(
      (failure) =>
          emit(CreateNewCustomerFailureState(mapFailureToMessage(failure))),
      (data) => emit(CreateNewCustomerSuccessState(data)),
    );
  }
}
