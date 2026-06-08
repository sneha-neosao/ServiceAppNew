part of 'amc_visit_reports_bloc.dart';

abstract class AmcVisitReportsState extends Equatable {
  const AmcVisitReportsState();

  @override
  List<Object?> get props => [];
}

class AmcVisitReportsInitialState extends AmcVisitReportsState {}

class AmcVisitReportsLoadingState extends AmcVisitReportsState {}

class AmcVisitReportsSuccessState extends AmcVisitReportsState {
  final AmcVisitReportsResponse data;

  const AmcVisitReportsSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class AmcVisitReportsFailureState extends AmcVisitReportsState {
  final String errorMessage;

  const AmcVisitReportsFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
