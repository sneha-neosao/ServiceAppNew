import 'package:equatable/equatable.dart';

sealed class CommissioningWorkDeleteEvent extends Equatable {
  const CommissioningWorkDeleteEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkDeleteSubmitEvent extends CommissioningWorkDeleteEvent {
  final String workId;

  const CommissioningWorkDeleteSubmitEvent(this.workId);

  @override
  List<Object?> get props => [workId];
}
