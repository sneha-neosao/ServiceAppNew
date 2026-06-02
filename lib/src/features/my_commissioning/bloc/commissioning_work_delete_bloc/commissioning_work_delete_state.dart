import 'package:equatable/equatable.dart';

sealed class CommissioningWorkDeleteState extends Equatable {
  const CommissioningWorkDeleteState();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkDeleteInitialState extends CommissioningWorkDeleteState {
  const CommissioningWorkDeleteInitialState();
}

class CommissioningWorkDeleteLoadingState extends CommissioningWorkDeleteState {
  const CommissioningWorkDeleteLoadingState();
}

class CommissioningWorkDeleteSuccessState extends CommissioningWorkDeleteState {
  final String message;

  const CommissioningWorkDeleteSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class CommissioningWorkDeleteFailureState extends CommissioningWorkDeleteState {
  final String message;

  const CommissioningWorkDeleteFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
