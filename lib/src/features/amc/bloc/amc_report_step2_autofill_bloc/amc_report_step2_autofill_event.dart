import 'package:equatable/equatable.dart';

abstract class AmcReportStep2AutofillEvent extends Equatable {
  const AmcReportStep2AutofillEvent();

  @override
  List<Object?> get props => [];
}

class GetAmcReportStep2AutofillEvent extends AmcReportStep2AutofillEvent {
  final String reportId;

  const GetAmcReportStep2AutofillEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
