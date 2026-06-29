import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/amc/domain/usecase/get_amc_report_step1_autofill_usecase.dart';

import 'amc_report_step1_autofill_event.dart';
import 'amc_report_step1_autofill_state.dart';

class AmcReportStep1AutofillBloc
    extends Bloc<AmcReportStep1AutofillEvent, AmcReportStep1AutofillState> {
  final GetAmcReportStep1AutofillUsecase getAmcReportStep1AutofillUsecase;

  AmcReportStep1AutofillBloc(this.getAmcReportStep1AutofillUsecase)
      : super(AmcReportStep1AutofillInitialState()) {
    on<GetAmcReportStep1AutofillEvent>((event, emit) async {
      emit(AmcReportStep1AutofillLoadingState());

      final result = await getAmcReportStep1AutofillUsecase(event.reportId);

      result.fold(
        (failure) => emit(AmcReportStep1AutofillFailureState(failure.message)),
        (data) => emit(AmcReportStep1AutofillSuccessState(data)),
      );
    });
  }
}
