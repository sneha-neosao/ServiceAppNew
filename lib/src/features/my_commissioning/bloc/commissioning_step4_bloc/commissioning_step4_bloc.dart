import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/commissioning_step4_usecase.dart';
import 'commissioning_step4_event.dart';
import 'commissioning_step4_state.dart';

class CommissioningStep4Bloc extends Bloc<CommissioningStep4Event, CommissioningStep4State> {
  final CommissioningStep4Usecase usecase;

  CommissioningStep4Bloc(this.usecase) : super(CommissioningStep4InitialState()) {
    on<CommissioningStep4GetEvent>((event, emit) async {
      emit(CommissioningStep4LoadingState());

      final result = await usecase(CommissioningStep4Params(
        id: event.commissioning_report_id,
        descriptions: event.descriptions,
      ));
      
      result.fold(
        (failure) {
          if (failure is CredentialFailure) {
            emit(CommissioningStep4FailureState(failure.message));
          } else if (failure is ApiFailure) {
            emit(CommissioningStep4FailureState(failure.message));
          } else {
            emit(CommissioningStep4FailureState(failure.message));
          }
        },
        (success) {
          emit(CommissioningStep4SuccessState(success));
        },
      );
    });
  }
}
