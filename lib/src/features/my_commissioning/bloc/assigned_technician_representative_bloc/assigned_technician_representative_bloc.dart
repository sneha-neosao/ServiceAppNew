import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/assigned_technician_representative_usecase.dart';
import 'assigned_technician_representative_event.dart';
import 'assigned_technician_representative_state.dart';

class AssignedTechnicianRepresentativeBloc
    extends
        Bloc<
          AssignedTechnicianRepresentativeEvent,
          AssignedTechnicianRepresentativeState
        > {
  final AssignedTechnicianRepresentativeUsecase usecase;

  AssignedTechnicianRepresentativeBloc(this.usecase)
    : super(AssignedTechnicianRepresentativeInitialState()) {
    on<AssignedTechnicianRepresentativeGetEvent>((event, emit) async {
      emit(AssignedTechnicianRepresentativeLoadingState());

      final result = await usecase(
        AssignedTechnicianRepresentativeParams(event.commissioning_report_id),
      );

      result.fold(
        (failure) {
          emit(AssignedTechnicianRepresentativeFailureState(failure.message));
        },
        (success) {
          emit(AssignedTechnicianRepresentativeSuccessState(success));
        },
      );
    });
  }
}
