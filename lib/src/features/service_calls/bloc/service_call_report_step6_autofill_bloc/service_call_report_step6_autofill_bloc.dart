import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/service_call_report_step6_autofill_usecase.dart';
import 'service_call_report_step6_autofill_event.dart';
import 'service_call_report_step6_autofill_state.dart';

class ServiceCallReportStep6AutoFillBloc extends Bloc<ServiceCallReportStep6AutoFillEvent, ServiceCallReportStep6AutoFillState> {
  final ServiceCallReportStep6AutoFillUsecase usecase;

  ServiceCallReportStep6AutoFillBloc(this.usecase) : super(ServiceCallReportStep6AutoFillInitialState()) {
    on<ServiceCallReportStep6AutoFillGetEvent>((event, emit) async {
      emit(ServiceCallReportStep6AutoFillLoadingState());

      final result = await usecase(event.reportId);
      
      result.fold(
        (failure) {
          emit(ServiceCallReportStep6AutoFillFailureState(failure.message));
        },
        (success) {
          emit(ServiceCallReportStep6AutoFillSuccessState(success));
        },
      );
    });
  }
}
