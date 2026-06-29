import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_report_step2_autofill_usecase.dart';

import 'amc_report_step2_autofill_event.dart';
import 'amc_report_step2_autofill_state.dart';

class AmcReportStep2AutofillBloc
    extends Bloc<AmcReportStep2AutofillEvent, AmcReportStep2AutofillState> {
  final GetAmcReportStep2AutofillUsecase getAmcReportStep2AutofillUsecase;

  AmcReportStep2AutofillBloc(this.getAmcReportStep2AutofillUsecase)
      : super(AmcReportStep2AutofillInitialState()) {
    on<GetAmcReportStep2AutofillEvent>((event, emit) async {
      emit(AmcReportStep2AutofillLoadingState());

      final result = await getAmcReportStep2AutofillUsecase(event.reportId);

      result.fold(
        (failure) => emit(AmcReportStep2AutofillFailureState(failure.message)),
        (data) => emit(AmcReportStep2AutofillSuccessState(data)),
      );
    });
  }
}
