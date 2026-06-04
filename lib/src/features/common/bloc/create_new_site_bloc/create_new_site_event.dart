import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_site_usecase.dart';

abstract class CreateNewSiteEvent extends Equatable {
  const CreateNewSiteEvent();

  @override
  List<Object?> get props => [];
}

class CreateNewSiteSubmitEvent extends CreateNewSiteEvent {
  final CreateNewSiteParams params;

  const CreateNewSiteSubmitEvent(this.params);

  @override
  List<Object?> get props => [params];
}
