import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step1_usecase.dart';

import 'amc_report_step1_event.dart';
import 'amc_report_step1_state.dart';

class AmcReportStep1Bloc
    extends Bloc<AmcReportStep1Event, AmcReportStep1State> {
  final PostAmcReportStep1Usecase postAmcReportStep1Usecase;

  AmcReportStep1Bloc(this.postAmcReportStep1Usecase)
      : super(AmcReportStep1InitialState()) {
    on<PostAmcReportStep1Event>((event, emit) async {
      emit(AmcReportStep1LoadingState());

      final result = await postAmcReportStep1Usecase(event.params);

      result.fold(
        (failure) => emit(AmcReportStep1FailureState(failure.message)),
        (data) => emit(AmcReportStep1SuccessState(data)),
      );
    });
  }
}
