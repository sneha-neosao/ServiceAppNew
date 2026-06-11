import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/domain/usecases/amc_report/get_amc_assigned_technicians_usecase.dart';

import 'amc_assigned_technicians_event.dart';
import 'amc_assigned_technicians_state.dart';

class AmcAssignedTechniciansBloc
    extends Bloc<AmcAssignedTechniciansEvent, AmcAssignedTechniciansState> {
  final GetAmcAssignedTechniciansUsecase getAmcAssignedTechniciansUsecase;

  AmcAssignedTechniciansBloc(this.getAmcAssignedTechniciansUsecase)
      : super(AmcAssignedTechniciansInitialState()) {
    on<GetAmcAssignedTechniciansEvent>((event, emit) async {
      emit(AmcAssignedTechniciansLoadingState());

      final result = await getAmcAssignedTechniciansUsecase(event.reportId);

      result.fold(
        (failure) => emit(AmcAssignedTechniciansFailureState(failure.message)),
        (data) => emit(AmcAssignedTechniciansSuccessState(data)),
      );
    });
  }
}
