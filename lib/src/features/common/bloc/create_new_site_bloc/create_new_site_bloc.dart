import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/failure_converter.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_site_usecase.dart';

import 'create_new_site_event.dart';
import 'create_new_site_state.dart';

class CreateNewSiteBloc extends Bloc<CreateNewSiteEvent, CreateNewSiteState> {
  final CreateNewSiteUsecase _createNewSiteUsecase;

  CreateNewSiteBloc(this._createNewSiteUsecase) : super(CreateNewSiteInitialState()) {
    on<CreateNewSiteSubmitEvent>(_onCreateNewSiteSubmitEvent);
  }

  void _onCreateNewSiteSubmitEvent(
      CreateNewSiteSubmitEvent event, Emitter<CreateNewSiteState> emit) async {
    emit(CreateNewSiteLoadingState());

    final result = await _createNewSiteUsecase(event.params);

    result.fold(
      (failure) => emit(CreateNewSiteFailureState(mapFailureToMessage(failure))),
      (data) => emit(CreateNewSiteSuccessState(data)),
    );
  }
}
