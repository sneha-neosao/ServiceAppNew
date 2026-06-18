import 'package:equatable/equatable.dart';

abstract class AmcReportStep1AutofillEvent extends Equatable {
  const AmcReportStep1AutofillEvent();

  @override
  List<Object?> get props => [];
}

class GetAmcReportStep1AutofillEvent extends AmcReportStep1AutofillEvent {
  final String reportId;

  const GetAmcReportStep1AutofillEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
