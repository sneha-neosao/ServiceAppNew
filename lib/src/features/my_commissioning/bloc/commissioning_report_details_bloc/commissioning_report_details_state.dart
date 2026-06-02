import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_details_response.dart';

sealed class CommissioningReportDetailsState extends Equatable {
  const CommissioningReportDetailsState();

  @override
  List<Object?> get props => [];
}

class CommissioningReportDetailsInitialState
    extends CommissioningReportDetailsState {
  const CommissioningReportDetailsInitialState();
}

class CommissioningReportDetailsLoadingState
    extends CommissioningReportDetailsState {
  const CommissioningReportDetailsLoadingState();
}

class CommissioningReportDetailsSuccessState
    extends CommissioningReportDetailsState {
  final CommissioningDetailsResponse data;
  const CommissioningReportDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningReportDetailsFailureState
    extends CommissioningReportDetailsState {
  final String message;
  const CommissioningReportDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
