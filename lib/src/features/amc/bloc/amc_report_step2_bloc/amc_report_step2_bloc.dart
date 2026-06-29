import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step2_usecase.dart';
import 'amc_report_step2_event.dart';
import 'amc_report_step2_state.dart';

class AmcReportStep2Bloc extends Bloc<AmcReportStep2Event, AmcReportStep2State> {
  final PostAmcReportStep2Usecase postAmcReportStep2Usecase;

  AmcReportStep2Bloc(this.postAmcReportStep2Usecase) : super(AmcReportStep2InitialState()) {
    on<PostAmcReportStep2Event>((event, emit) async {
      emit(AmcReportStep2LoadingState());
      final result = await postAmcReportStep2Usecase(event.params);
      result.fold(
        (failure) => emit(AmcReportStep2ErrorState(failure.message)),
        (data) => emit(AmcReportStep2SuccessState(data)),
      );
    });
  }
}
