import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/close_over_call_usecase.dart';

abstract class CloseOverCallEvent extends Equatable {
  const CloseOverCallEvent();

  @override
  List<Object?> get props => [];
}

class CloseOverCallPostEvent extends CloseOverCallEvent {
  final CloseOverCallParams params;

  const CloseOverCallPostEvent(this.params);

  @override
  List<Object?> get props => [params];
}
