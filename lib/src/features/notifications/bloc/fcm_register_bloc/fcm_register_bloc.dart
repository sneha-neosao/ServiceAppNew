import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/utils/failure_converter.dart';
import 'package:service_app/src/features/notifications/domain/usecase/fcm_register_usecase.dart';

import 'fcm_register_event.dart';
import 'fcm_register_state.dart';

class FcmRegisterBloc extends Bloc<FcmRegisterEvent, FcmRegisterState> {
  final FcmRegisterUseCase fcmRegisterUseCase;

  FcmRegisterBloc({required this.fcmRegisterUseCase}) : super(FcmRegisterInitial()) {
    on<FcmRegisterTriggerEvent>(_onFcmRegisterTrigger);
  }

  Future<void> _onFcmRegisterTrigger(
    FcmRegisterTriggerEvent event,
    Emitter<FcmRegisterState> emit,
  ) async {
    emit(FcmRegisterLoading());
    final result = await fcmRegisterUseCase(
      FcmRegisterParams(fcmToken: event.fcmToken),
    );
    result.fold(
      (failure) => emit(FcmRegisterFailure(mapFailureToMessage(failure))),
      (response) => emit(FcmRegisterSuccess(response)),
    );
  }
}
