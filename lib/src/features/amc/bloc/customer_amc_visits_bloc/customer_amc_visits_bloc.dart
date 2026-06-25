import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/remote/models/amc_visit_model/customer_amc_visits_response.dart';

import '../../domain/usecase/get_customer_amc_visits_usecase.dart';
import 'customer_amc_visits_event.dart';
import 'customer_amc_visits_state.dart';

class CustomerAmcVisitsBloc extends Bloc<CustomerAmcVisitsEvent, CustomerAmcVisitsState> {
  final GetCustomerAmcVisitsUseCase getCustomerAmcVisitsUseCase;

  int _currentPage = 1;
  String _currentCustomerId = '';
  final List<CustomerAmcVisitItem> _allVisits = [];
  bool _hasMore = true;

  CustomerAmcVisitsBloc({required this.getCustomerAmcVisitsUseCase})
      : super(CustomerAmcVisitsInitial()) {
    on<GetCustomerAmcVisitsEvent>(_onGetCustomerAmcVisitsEvent);
  }

  Future<void> _onGetCustomerAmcVisitsEvent(
    GetCustomerAmcVisitsEvent event,
    Emitter<CustomerAmcVisitsState> emit,
  ) async {
    if (event.customerId != _currentCustomerId || event.page == 1) {
      _currentCustomerId = event.customerId;
      _currentPage = 1;
      _allVisits.clear();
      _hasMore = true;
    }

    if (!_hasMore && event.page > 1) return;

    if (_currentPage == 1) {
      emit(CustomerAmcVisitsLoading());
    }

    final params = CustomerAmcVisitsParams(
      customerId: _currentCustomerId,
      page: _currentPage,
      pageSize: event.pageSize,
    );

    final result = await getCustomerAmcVisitsUseCase(params);

    result.fold(
      (failure) => emit(CustomerAmcVisitsError(failure.message)),
      (response) {
        final dataList = response.data?.results ?? [];
        if (dataList.isEmpty || dataList.length < event.pageSize) {
          _hasMore = false;
        }

        _allVisits.addAll(dataList);

        final newData = CustomerAmcVisitsData(
          results: List.from(_allVisits),
          pagination: response.data?.pagination,
        );

        final newResponse = CustomerAmcVisitsResponse(
          status: response.status,
          success: response.success,
          message: response.message,
          data: newData,
        );

        _currentPage++;
        emit(CustomerAmcVisitsSuccess(newResponse));
      },
    );
  }
}
