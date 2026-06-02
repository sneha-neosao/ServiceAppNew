import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/commissioning_step5_usecase.dart';
import 'commissioning_step5_event.dart';
import 'commissioning_step5_state.dart';

class CommissioningStep5Bloc extends Bloc<CommissioningStep5Event, CommissioningStep5State> {
  final CommissioningStep5Usecase usecase;

  CommissioningStep5Bloc(this.usecase) : super(CommissioningStep5InitialState()) {
    on<CommissioningStep5GetEvent>((event, emit) async {
      emit(CommissioningStep5LoadingState());

      final result = await usecase(CommissioningStep5Params(
        id: event.commissioning_report_id,
        isMechanicalChecklistNa: event.isMechanicalChecklistNa,
        isPipelineChecklistNa: event.isPipelineChecklistNa,
        isElectricalChecklistNa: event.isElectricalChecklistNa,
        checklistItems: event.checklistItems,
      ));
      
      result.fold(
        (failure) {
          if (failure is CredentialFailure) {
            emit(CommissioningStep5FailureState(failure.message));
          } else if (failure is ApiFailure) {
            emit(CommissioningStep5FailureState(failure.message));
          } else {
            emit(CommissioningStep5FailureState(failure.message));
          }
        },
        (success) {
          emit(CommissioningStep5SuccessState(success));
        },
      );
    });
  }
}
