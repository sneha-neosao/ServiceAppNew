import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_history_response.dart';

abstract class AmcReportsHistoryState extends Equatable {
  const AmcReportsHistoryState();

  @override
  List<Object> get props => [];
}

class AmcReportsHistoryInitial extends AmcReportsHistoryState {}

class AmcReportsHistoryLoadingState extends AmcReportsHistoryState {}

class AmcReportsHistorySuccessState extends AmcReportsHistoryState {
  final AmcHistoryResponse response;
  final int timestamp;

  AmcReportsHistorySuccessState(this.response) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [response, timestamp];
}

class AmcReportsHistoryErrorState extends AmcReportsHistoryState {
  final String errorMessage;

  const AmcReportsHistoryErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
