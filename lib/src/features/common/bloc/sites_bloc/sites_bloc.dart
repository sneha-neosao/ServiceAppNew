import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/core/utils/logger.dart';
import 'package:service_app/src/features/common/domain/usecase/sites_usecase.dart';
import 'package:service_app/src/features/common/domain/usecase/technician_usecase.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';

part 'sites_event.dart';
part 'sites_state.dart';

/// Handles state management for **Sites** and its related entities.

class SitesBloc extends Bloc<SitesEvent, SitesState> {
  final SitesUseCase _sitesUseCase;
  SitesBloc(this._sitesUseCase) : super(SitesinitialState()) {
    on<SitesGetEvent>(_sites);
  }

  /// - **Sites:** Handles [SitesGetEvent] → calls [TechnicianUseCase]
  Future _sites(SitesGetEvent event, Emitter emit) async {
    emit(SitesLoadingState());

    final result = await _sitesUseCase.call(
      SitesParams(customer_id: event.customer_id),
    );

    // fold() is synchronous — never put async work inside its callbacks.
    // Instead check the result and await outside fold.
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(SitesFailureState(failure.message));
    } else {
      final data = result.getRight().toNullable()!;
      emit(SitesSuccessState(data));
    }
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE SitesBloc =====");
    return super.close();
  }
}
