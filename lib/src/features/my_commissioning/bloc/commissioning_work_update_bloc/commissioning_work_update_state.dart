import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_work_create_model/commissioning_work_create_response.dart';

sealed class CommissioningWorkUpdateState extends Equatable {
  const CommissioningWorkUpdateState();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkUpdateInitialState extends CommissioningWorkUpdateState {
  const CommissioningWorkUpdateInitialState();
}

class CommissioningWorkUpdateLoadingState extends CommissioningWorkUpdateState {
  const CommissioningWorkUpdateLoadingState();
}

class CommissioningWorkUpdateSuccessState extends CommissioningWorkUpdateState {
  final CommissioningWorkCreateResponse data;

  const CommissioningWorkUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningWorkUpdateFailureState extends CommissioningWorkUpdateState {
  final String message;

  const CommissioningWorkUpdateFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
