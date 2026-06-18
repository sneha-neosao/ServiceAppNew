import 'package:equatable/equatable.dart';

abstract class AmcReportsHistoryEvent extends Equatable {
  const AmcReportsHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetAmcReportsHistoryEvent extends AmcReportsHistoryEvent {}
