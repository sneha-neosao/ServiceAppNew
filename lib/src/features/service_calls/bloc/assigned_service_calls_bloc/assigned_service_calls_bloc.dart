import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assigned_service_calls_usecase.dart';
import 'package:service_app/src/remote/models/service_calls_model/assigned_service_calls_response.dart';

import 'assigned_service_calls_event.dart';
import 'assigned_service_calls_state.dart';

class AssignedServiceCallsBloc
    extends Bloc<AssignedServiceCallsEvent, AssignedServiceCallsState> {
  final AssignedServiceCallsUseCase _useCase;

  AssignedServiceCallsResponse? _currentData;
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  AssignedServiceCallsBloc(this._useCase)
    : super(AssignedServiceCallsInitialState()) {
    on<AssignedServiceCallsGetEvent>(_onGetAssignedServiceCalls);
  }

  Future<void> _onGetAssignedServiceCalls(
    AssignedServiceCallsGetEvent event,
    Emitter<AssignedServiceCallsState> emit,
  ) async {
    if (_isFetching) return;

    if (event.isRefresh || _currentData == null) {
      _currentPage = 1;
      _currentData = null;
      _hasMore = true;
      emit(AssignedServiceCallsLoadingState());
    } else {
      if (!_hasMore) return;
      _currentPage++;
      emit(AssignedServiceCallsPaginationLoadingState(_currentData!));
    }

    _isFetching = true;

    final params = AssignedServiceCallsParams(
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
          emit(AssignedServiceCallsSuccessState(_currentData!));
        } else {
          emit(AssignedServiceCallsFailureState(failure.message));
        }
      },
      (response) {
        _isFetching = false;

        if (_currentData == null) {
          _currentData = response;
        } else {
          final updatedResults = List<ServiceCallResult>.from(
            _currentData!.data.results,
          )..addAll(response.data.results);
          final updatedData = AssignedServiceCallsData(
            results: updatedResults,
            pagination: response.data.pagination,
          );
          _currentData = AssignedServiceCallsResponse(
            status: response.status,
            success: response.success,
            data: updatedData,
            message: response.message,
          );
        }

        _hasMore =
            response.data.pagination.page < response.data.pagination.totalPages;

        emit(AssignedServiceCallsSuccessState(_currentData!));
      },
    );
  }
}
