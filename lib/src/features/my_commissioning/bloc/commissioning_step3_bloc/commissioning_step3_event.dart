import 'package:equatable/equatable.dart';

import '../../../../remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';

sealed class CommissioningStep3Event extends Equatable {
  const CommissioningStep3Event();

  @override
  List<Object?> get props => [];
}

class CommissioningStep3GetEvent extends CommissioningStep3Event {
  final String id;
  final bool isTechnicalNa;
  final TechnicalDetails? technicalDetails;

  const CommissioningStep3GetEvent(
      this.id,
      this.isTechnicalNa,
      this.technicalDetails,
      );

  @override
  List<Object?> get props => [
    id,
    isTechnicalNa,
    technicalDetails,
  ];
}
