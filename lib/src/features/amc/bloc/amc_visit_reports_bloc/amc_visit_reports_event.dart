part of 'amc_visit_reports_bloc.dart';

abstract class AmcVisitReportsEvent extends Equatable {
  const AmcVisitReportsEvent();

  @override
  List<Object?> get props => [];
}

class AmcVisitReportsGetEvent extends AmcVisitReportsEvent {
  final String visitId;

  const AmcVisitReportsGetEvent({required this.visitId});

  @override
  List<Object?> get props => [visitId];
}
