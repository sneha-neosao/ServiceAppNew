import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/commissioning_step6_autofill_usecase.dart';
import 'commissioning_step6_autofill_event.dart';
import 'commissioning_step6_autofill_state.dart';

class CommissioningStep6AutoFillBloc extends Bloc<CommissioningStep6AutoFillEvent, CommissioningStep6AutoFillState> {
  final CommissioningStep6AutofillUsecase usecase;

  CommissioningStep6AutoFillBloc(this.usecase) : super(CommissioningStep6AutoFillInitialState()) {
    on<CommissioningStep6AutoFillGetEvent>((event, emit) async {
      emit(CommissioningStep6AutoFillLoadingState());

      final result = await usecase(CommissioningStep6AutofillParams(
        event.commissioning_report_id,
      ));
      
      result.fold(
        (failure) {
          emit(CommissioningStep6AutoFillFailureState(failure.message));
        },
        (success) {
          emit(CommissioningStep6AutoFillSuccessState(success));
        },
      );
    });
  }
}
