import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/commissioning_step4_autofill_usecase.dart';
import 'commissioning_step4_autofill_event.dart';
import 'commissioning_step4_autofill_state.dart';

class CommissioningStep4AutoFillBloc extends Bloc<CommissioningStep4AutoFillEvent, CommissioningStep4AutoFillState> {
  final CommissioningStep4AutofillUsecase usecase;

  CommissioningStep4AutoFillBloc(this.usecase) : super(CommissioningStep4AutoFillInitialState()) {
    on<CommissioningStep4AutoFillGetEvent>((event, emit) async {
      emit(CommissioningStep4AutoFillLoadingState());

      final result = await usecase(CommissioningStep4AutofillParams(
        event.commissioning_report_id,
      ));
      
      result.fold(
        (failure) {
          if (failure is CredentialFailure) {
            emit(CommissioningStep4AutoFillFailureState(failure.message));
          } else if (failure is ApiFailure) {
            emit(CommissioningStep4AutoFillFailureState(failure.message));
          } else {
            emit(CommissioningStep4AutoFillFailureState(failure.message));
          }
        },
        (success) {
          emit(CommissioningStep4AutoFillSuccessState(success));
        },
      );
    });
  }
}
