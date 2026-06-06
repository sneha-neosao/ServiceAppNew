import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/technician_usecase.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';

part 'sites_event.dart';
part 'sites_state.dart';

/// Handles state management for **Sites** and its related entities.

class SitesBloc extends Bloc<SitesEvent, SitesState> {
  final SitesUseCase _sitesUseCase;

  int _currentPage = 1;
  String _currentSearch = '';
  String _currentCustomerId = '';
  List<Site> _allSites = [];
  bool _hasMore = true;

  SitesBloc(this._sitesUseCase) : super(SitesinitialState()) {
    on<SitesGetEvent>(_sites);
  }

  /// - **Sites:** Handles [SitesGetEvent] → calls [SitesUseCase]
  Future _sites(SitesGetEvent event, Emitter emit) async {
    // If search text or customer id changed, reset everything
    if (event.search != _currentSearch ||
        event.customer_id != _currentCustomerId) {
      _currentSearch = event.search;
      _currentCustomerId = event.customer_id;
      _currentPage = 1;
      _allSites.clear();
      _hasMore = true;
    }

    if (!_hasMore && event.page > 1) return;

    if (_currentPage == 1) {
      emit(SitesLoadingState());
    }

    final result = await _sitesUseCase.call(
      SitesParams(
        customer_id: _currentCustomerId,
        page: _currentPage,
        pageSize: event.pageSize,
        search: _currentSearch,
      ),
    );

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(SitesFailureState(failure.message));
    } else {
      final response = result.getRight().toNullable()!;

      if (response.data.isEmpty || response.data.length < event.pageSize) {
        _hasMore = false;
      }

      _allSites.addAll(response.data);

      final newResponse = SiteResponse(
        status: response.status,
        success: response.success,
        message: response.message,
        data: List.from(_allSites),
      );

      _currentPage++;
      emit(SitesSuccessState(newResponse));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SitesBloc =====");
    return super.close();
  }
}
