import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_reports_history_usecase.dart';
import 'amc_reports_history_event.dart';
import 'amc_reports_history_state.dart';

import 'package:service_app/src/remote/models/amc_report_model/amc_history_response.dart';

class AmcReportsHistoryBloc
    extends Bloc<AmcReportsHistoryEvent, AmcReportsHistoryState> {
  final GetAmcReportsHistoryUseCase getAmcReportsHistoryUseCase;

  int _currentPage = 1;
  bool _hasMore = true;
  final List<AmcHistoryData> _allReports = [];
  String? _lastCustomerName;
  String? _lastSiteName;
  String? _lastDateFrom;
  String? _lastDateTo;

  AmcReportsHistoryBloc(this.getAmcReportsHistoryUseCase)
    : super(AmcReportsHistoryInitial()) {
    on<GetAmcReportsHistoryEvent>((event, emit) async {
      bool isNewSearch =
          event.customerName != _lastCustomerName ||
          event.siteName != _lastSiteName ||
          event.dateFrom != _lastDateFrom ||
          event.dateTo != _lastDateTo ||
          event.page == 1;

      if (isNewSearch) {
        _currentPage = 1;
        _hasMore = true;
        _allReports.clear();
        _lastCustomerName = event.customerName;
        _lastSiteName = event.siteName;
        _lastDateFrom = event.dateFrom;
        _lastDateTo = event.dateTo;
      }

      if (!_hasMore && event.page > 1) return;

      if (_currentPage == 1) {
        emit(AmcReportsHistoryLoadingState());
      }

      final result = await getAmcReportsHistoryUseCase.call(
        AmcReportsHistoryParams(
          customerName: event.customerName,
          siteName: event.siteName,
          dateFrom: event.dateFrom,
          dateTo: event.dateTo,
          page: _currentPage,
          pageSize: event.pageSize,
        ),
      );

      result.fold(
        (failure) => emit(AmcReportsHistoryErrorState(failure.message)),
        (response) {
          final dataList = response.data?.results ?? [];
          if (dataList.isEmpty || dataList.length < event.pageSize) {
            _hasMore = false;
          }

          _allReports.addAll(dataList);

          final newData = AmcHistoryReportData(
            results: List.from(_allReports),
            pagination: response.data?.pagination,
          );

          final newResponse = AmcHistoryResponse(
            status: response.status,
            success: response.success,
            message: response.message,
            data: newData,
          );

          _currentPage++;
          emit(AmcReportsHistorySuccessState(newResponse));
        },
      );
    });
  }
}
