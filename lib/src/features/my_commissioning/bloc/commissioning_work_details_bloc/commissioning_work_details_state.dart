import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_details_response.dart';

sealed class CommissioningWorkDetailsState extends Equatable {
  const CommissioningWorkDetailsState();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkDetailsInitialState extends CommissioningWorkDetailsState {
  const CommissioningWorkDetailsInitialState();
}

class CommissioningWorkDetailsLoadingState extends CommissioningWorkDetailsState {
  const CommissioningWorkDetailsLoadingState();
}

class CommissioningWorkDetailsSuccessState extends CommissioningWorkDetailsState {
  final CommissioningWorkDetailsResponse data;
  const CommissioningWorkDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CommissioningWorkDetailsFailureState extends CommissioningWorkDetailsState {
  final String message;
  const CommissioningWorkDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
