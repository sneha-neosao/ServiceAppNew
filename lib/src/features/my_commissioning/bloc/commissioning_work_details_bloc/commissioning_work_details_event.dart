import 'package:equatable/equatable.dart';

sealed class CommissioningWorkDetailsEvent extends Equatable {
  const CommissioningWorkDetailsEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkDetailsGetEvent extends CommissioningWorkDetailsEvent {
  final String workId;
  const CommissioningWorkDetailsGetEvent(this.workId);

  @override
  List<Object?> get props => [workId];
}
