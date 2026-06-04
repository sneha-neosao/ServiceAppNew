import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/profile/domain/usecase/profile_details_usecase.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';

part 'profile_details_event.dart';
part 'profile_details_state.dart';

/// Handles state management for **Profile Details** and its related entities.

class ProfileDetailsBloc
    extends Bloc<ProfileDetailsEvent, ProfileDetailsState> {
  final ProfileDetailsUseCase _profileDetailsUseCase;
  ProfileDetailsBloc(this._profileDetailsUseCase)
    : super(ProfileDetailsInitialState()) {
    on<ProfileDetailsGetEvent>(profileDetails);
  }

  /// - **Login:** Handles [ProfileDetailsGetEvent] → calls [ProfileDetailsUseCase]
  Future profileDetails(ProfileDetailsGetEvent event, Emitter emit) async {
    emit(ProfileDetailsLoadingState());

    final result = await _profileDetailsUseCase.call(NoParams());

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(ProfileDetailsFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      // // Persist sign-in status so splash can route correctly on next launch
      // await SessionManager.saveLoginStatus(true);
      // await SessionManager.saveUserSession(data);
      emit(ProfileDetailsSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ProfileDetailsBloc =====");
    return super.close();
  }
}
