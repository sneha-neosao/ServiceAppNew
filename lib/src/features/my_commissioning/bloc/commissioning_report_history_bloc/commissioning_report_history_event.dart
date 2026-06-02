import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';

sealed class CommissioningReportHistoryEvent extends Equatable {
  const CommissioningReportHistoryEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningReportHistoryGetEvent
    extends CommissioningReportHistoryEvent {
  final CommissioningReportHistoryParams params;
  const CommissioningReportHistoryGetEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
