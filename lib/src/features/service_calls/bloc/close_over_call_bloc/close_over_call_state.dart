import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/close_over_call_model/close_over_call_response.dart';

abstract class CloseOverCallState extends Equatable {
  const CloseOverCallState();

  @override
  List<Object?> get props => [];
}

class CloseOverCallInitialState extends CloseOverCallState {}

class CloseOverCallLoadingState extends CloseOverCallState {}

class CloseOverCallSuccessState extends CloseOverCallState {
  final CloseOverCallResponse data;

  const CloseOverCallSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CloseOverCallFailureState extends CloseOverCallState {
  final String message;

  const CloseOverCallFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
