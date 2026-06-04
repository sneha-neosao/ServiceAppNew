import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/technician_usecase.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';

part 'technician_event.dart';
part 'technician_state.dart';

/// Handles state management for **Technician** and its related entities.

class TechnicianBloc extends Bloc<TechnicianEvent, TechnicianState> {
  final TechnicianUseCase _technicianUseCase;
  TechnicianBloc(this._technicianUseCase) : super(TechniciannitialState()) {
    on<TechnicianGetEvent>(_technician);
  }

  /// - **Technician:** Handles [TechnicianGetEvent] → calls [TechnicianUseCase]
  Future _technician(TechnicianGetEvent event, Emitter emit) async {
    emit(TechnicianLoadingState());

    final result = await _technicianUseCase.call(NoParams());

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(TechnicianFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(TechnicianSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE TechnicianBloc =====");
    return super.close();
  }
}
