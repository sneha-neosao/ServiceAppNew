import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/customer_usecase.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';

part 'customer_event.dart';
part 'customer_state.dart';

/// Handles state management for **Customer** and its related entities.

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerUseCase _customerUseCase;

  int _currentPage = 1;
  String _currentSearch = '';
  List<Customer> _allCustomers = [];
  bool _hasMore = true;

  CustomerBloc(this._customerUseCase) : super(CustomerInitialState()) {
    on<CustomerGetEvent>(_customers);
  }

  /// - **Customer:** Handles [CustomerGetEvent] → calls [CustomerUseCase]
  Future _customers(CustomerGetEvent event, Emitter emit) async {
    // If search text changed, reset everything
    if (event.search != _currentSearch) {
      _currentSearch = event.search;
      _currentPage = 1;
      _allCustomers.clear();
      _hasMore = true;
    }

    // Only load more if there's more to load
    if (!_hasMore && event.page > 1) return;

    if (_currentPage == 1) {
      emit(CustomerLoadingState());
    }

    final result = await _customerUseCase.call(CustomerParams(
      page: _currentPage,
      pageSize: event.pageSize,
      search: _currentSearch,
    ));

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(CustomerFailureState(failure.message));
    } else {
      final response = result.getRight().toNullable()!;
      
      if (response.data.isEmpty || response.data.length < event.pageSize) {
        _hasMore = false;
      }
      
      _allCustomers.addAll(response.data);
      
      // We must emit a new CustomerResponse with the accumulated _allCustomers
      final newResponse = CustomerResponse(
        status: response.status,
        success: response.success,
        message: response.message,
        data: List.from(_allCustomers),
      );
      
      _currentPage++;
      emit(CustomerSuccessState(newResponse));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CustomerBloc =====");
    return super.close();
  }
}
