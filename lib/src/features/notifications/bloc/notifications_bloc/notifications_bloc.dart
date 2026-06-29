import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:service_app/src/remote/models/notifications_model/notifications_response.dart';

import 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsBloc({required this.getNotificationsUseCase})
    : super(NotificationsInitial()) {
    on<GetNotificationsEvent>((event, emit) async {
      if (event.isRefresh) {
        emit(NotificationsLoading());
      } else if (state is NotificationsInitial) {
        emit(NotificationsLoading());
      }

      final result = await getNotificationsUseCase(
        GetNotificationsParams(
          page: event.page,
          customerName: event.customerName,
          siteName: event.siteName,
          date: event.date,
        ),
      );

      result.fold(
        (failure) {
          emit(NotificationsError(message: failure.message));
        },
        (response) {
          final newNotifications = response.data?.results ?? [];
          final pagination = response.data?.pagination;
          final bool hasReachedMax =
              pagination?.page == pagination?.totalPages ||
              (pagination?.totalPages ?? 0) == 0;

          if (state is NotificationsLoaded && !event.isRefresh) {
            final currentState = state as NotificationsLoaded;
            emit(
              currentState.copyWith(
                response: response,
                notifications: List.of(currentState.notifications)
                  ..addAll(newNotifications),
                hasReachedMax: hasReachedMax,
              ),
            );
          } else {
            emit(
              NotificationsLoaded(
                response: response,
                notifications: newNotifications,
                hasReachedMax: hasReachedMax,
              ),
            );
          }
        },
      );
    });
  }
}
