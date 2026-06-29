import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/failure_converter.dart';
import 'package:service_app/src/features/home/domain/usecase/get_app_settings_usecase.dart';

import 'app_settings_event.dart';
import 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final GetAppSettingsUseCase getAppSettingsUseCase;

  AppSettingsBloc({required this.getAppSettingsUseCase})
    : super(AppSettingsInitial()) {
    on<GetAppSettingsEvent>(_onGetAppSettings);
  }

  Future<void> _onGetAppSettings(
    GetAppSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(AppSettingsLoading());
    final result = await getAppSettingsUseCase(NoParams());
    result.fold(
      (failure) => emit(AppSettingsFailure(mapFailureToMessage(failure))),
      (response) => emit(AppSettingsSuccess(response)),
    );
  }
}
