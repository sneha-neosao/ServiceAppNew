import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/notifications/domain/usecase/get_unread_count_usecase.dart';
import 'package:service_app/src/remote/models/notifications_model/unread_count_response.dart';

import 'unread_count_event.dart';

part 'unread_count_state.dart';

class UnreadCountBloc extends Bloc<UnreadCountEvent, UnreadCountState> {
  final GetUnreadNotificationCountUseCase getUnreadNotificationCountUseCase;

  UnreadCountBloc({required this.getUnreadNotificationCountUseCase})
    : super(UnreadCountInitial()) {
    on<GetUnreadNotificationCountEvent>((event, emit) async {
      emit(UnreadCountLoading());

      final result = await getUnreadNotificationCountUseCase(NoParams());

      result.fold(
        (failure) {
          emit(UnreadCountError(message: failure.message));
        },
        (response) {
          emit(UnreadCountLoaded(unreadCount: response.data?.unreadCount ?? 0));
        },
      );
    });
  }
}
