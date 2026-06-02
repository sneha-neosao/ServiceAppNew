import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_history_response.dart';

sealed class CommissioningReportHistoryState extends Equatable {
  const CommissioningReportHistoryState();

  @override
  List<Object?> get props => [];
}

class CommissioningReportHistoryInitialState
    extends CommissioningReportHistoryState {
  const CommissioningReportHistoryInitialState();
}

class CommissioningReportHistoryLoadingState
    extends CommissioningReportHistoryState {
  const CommissioningReportHistoryLoadingState();
}

class CommissioningReportHistorySuccessState
    extends CommissioningReportHistoryState {
  final CommissioningReportHistoryResponse data;
  const CommissioningReportHistorySuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningReportHistoryFailureState
    extends CommissioningReportHistoryState {
  final String message;
  const CommissioningReportHistoryFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
