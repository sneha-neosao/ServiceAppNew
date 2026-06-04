import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/commissioning_step5_autofill_usecase.dart';
import 'commissioning_step5_autofill_event.dart';
import 'commissioning_step5_autofill_state.dart';

class CommissioningStep5AutoFillBloc
    extends
        Bloc<CommissioningStep5AutoFillEvent, CommissioningStep5AutoFillState> {
  final CommissioningStep5AutofillUsecase usecase;

  CommissioningStep5AutoFillBloc(this.usecase)
    : super(CommissioningStep5AutoFillInitialState()) {
    on<CommissioningStep5AutoFillGetEvent>((event, emit) async {
      emit(CommissioningStep5AutoFillLoadingState());

      final result = await usecase(
        CommissioningStep5AutofillParams(event.commissioning_report_id),
      );

      result.fold(
        (failure) {
          if (failure is CredentialFailure) {
            emit(CommissioningStep5AutoFillFailureState(failure.message));
          } else if (failure is ApiFailure) {
            emit(CommissioningStep5AutoFillFailureState(failure.message));
          } else {
            emit(CommissioningStep5AutoFillFailureState(failure.message));
          }
        },
        (success) {
          emit(CommissioningStep5AutoFillSuccessState(success));
        },
      );
    });
  }
}
