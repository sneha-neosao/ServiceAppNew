import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:service_app/src/remote/models/notifications_model/mark_all_read_response.dart';

import 'mark_all_read_event.dart';

part 'mark_all_read_state.dart';

class MarkAllReadBloc extends Bloc<MarkAllReadEvent, MarkAllReadState> {
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;

  MarkAllReadBloc({required this.markAllNotificationsReadUseCase})
    : super(MarkAllReadInitial()) {
    on<MarkAllNotificationsReadEvent>((event, emit) async {
      emit(MarkAllReadLoading());

      final result = await markAllNotificationsReadUseCase(NoParams());

      result.fold(
        (failure) {
          emit(MarkAllReadError(message: failure.message));
        },
        (response) {
          emit(MarkAllReadSuccess(response: response));
        },
      );
    });
  }
}
