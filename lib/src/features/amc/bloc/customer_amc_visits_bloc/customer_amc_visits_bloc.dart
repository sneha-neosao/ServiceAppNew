import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/get_customer_amc_visits_usecase.dart';
import 'customer_amc_visits_event.dart';
import 'customer_amc_visits_state.dart';

class CustomerAmcVisitsBloc extends Bloc<CustomerAmcVisitsEvent, CustomerAmcVisitsState> {
  final GetCustomerAmcVisitsUseCase getCustomerAmcVisitsUseCase;

  CustomerAmcVisitsBloc({required this.getCustomerAmcVisitsUseCase})
      : super(CustomerAmcVisitsInitial()) {
    on<GetCustomerAmcVisitsEvent>(_onGetCustomerAmcVisitsEvent);
  }

  Future<void> _onGetCustomerAmcVisitsEvent(
    GetCustomerAmcVisitsEvent event,
    Emitter<CustomerAmcVisitsState> emit,
  ) async {
    emit(CustomerAmcVisitsLoading());
    final result = await getCustomerAmcVisitsUseCase(event.customerId);

    result.fold(
      (failure) => emit(CustomerAmcVisitsError(failure.message)),
      (response) => emit(CustomerAmcVisitsSuccess(response)),
    );
  }
}
