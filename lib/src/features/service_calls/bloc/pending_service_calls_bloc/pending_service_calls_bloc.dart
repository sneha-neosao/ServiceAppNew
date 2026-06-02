import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/pending_service_calls_usecase.dart';
import 'package:service_app/src/remote/models/service_calls_model/pending_serbice_calls_response.dart';

import 'pending_service_calls_event.dart';
import 'pending_service_calls_state.dart';

class PendingServiceCallsBloc extends Bloc<PendingServiceCallsEvent, PendingServiceCallsState> {
  final PendingServiceCallsUseCase _useCase;
  
  PendingServiceCallsResponse? _currentData;
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  PendingServiceCallsBloc(this._useCase) : super(PendingServiceCallsInitialState()) {
    on<PendingServiceCallsGetEvent>(_onGetPendingServiceCalls);
  }

  Future<void> _onGetPendingServiceCalls(
    PendingServiceCallsGetEvent event,
    Emitter<PendingServiceCallsState> emit,
  ) async {
    if (_isFetching) return;

    if (event.isRefresh || _currentData == null) {
      _currentPage = 1;
      _currentData = null;
      _hasMore = true;
      emit(PendingServiceCallsLoadingState());
    } else {
      if (!_hasMore) return;
      _currentPage++;
      emit(PendingServiceCallsPaginationLoadingState(_currentData!));
    }

    _isFetching = true;

    final params = PendingServiceCallsParams(
      page: _currentPage,
      pageSize: event.pageSize,
      customerId: event.customerId,
      siteId: event.siteId,
      complaintNumber: event.complaintNumber,
      date: event.date,
    );

    final result = await _useCase(params);

    result.fold(
      (failure) {
        _isFetching = false;
        // Revert page increment if it failed
        if (!event.isRefresh && _currentData != null) {
          _currentPage--;
          emit(PendingServiceCallsSuccessState(_currentData!));
        } else {
          emit(PendingServiceCallsFailureState(failure.message));
        }
      },
      (response) {
        _isFetching = false;

        if (_currentData == null) {
          _currentData = response;
        } else {
          final updatedResults = List<ServiceCallResult>.from(_currentData!.data.results)..addAll(response.data.results);
          final updatedData = PendingServiceCallsData(
            results: updatedResults,
            pagination: response.data.pagination,
          );
          _currentData = PendingServiceCallsResponse(
            status: response.status,
            success: response.success,
            data: updatedData,
            message: response.message,
          );
        }

        _hasMore = response.data.pagination.page < response.data.pagination.totalPages;

        emit(PendingServiceCallsSuccessState(_currentData!));
      },
    );
  }
}
