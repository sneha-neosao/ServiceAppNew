import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/create_new_site_model/create_new_site_response.dart';

abstract class CreateNewSiteState extends Equatable {
  const CreateNewSiteState();

  @override
  List<Object?> get props => [];
}

class CreateNewSiteInitialState extends CreateNewSiteState {}

class CreateNewSiteLoadingState extends CreateNewSiteState {}

class CreateNewSiteSuccessState extends CreateNewSiteState {
  final AddSiteResponse data;

  const CreateNewSiteSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CreateNewSiteFailureState extends CreateNewSiteState {
  final String message;

  const CreateNewSiteFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
