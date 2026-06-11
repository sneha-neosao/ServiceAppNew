import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/domain/usecases/amc_report/post_amc_report_step3_usecase.dart';
import 'amc_report_step3_event.dart';
import 'amc_report_step3_state.dart';

class AmcReportStep3Bloc extends Bloc<AmcReportStep3Event, AmcReportStep3State> {
  final PostAmcReportStep3UseCase postAmcReportStep3UseCase;

  AmcReportStep3Bloc(this.postAmcReportStep3UseCase) : super(AmcReportStep3InitialState()) {
    on<PostAmcReportStep3Event>((event, emit) async {
      emit(AmcReportStep3LoadingState());
      final result = await postAmcReportStep3UseCase(event.params);
      result.fold(
        (failure) => emit(AmcReportStep3ErrorState(failure.message)),
        (data) => emit(AmcReportStep3SuccessState(data)),
      );
    });
  }
}
