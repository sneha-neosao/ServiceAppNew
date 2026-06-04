import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step6_usecase.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'service_call_report_step6_event.dart';
import 'service_call_report_step6_state.dart';

class ServiceCallReportStep6Bloc
    extends Bloc<ServiceCallReportStep6Event, ServiceCallReportStep6State> {
  final ServiceCallReportStep6Usecase usecase;

  ServiceCallReportStep6Bloc({required this.usecase})
    : super(ServiceCallReportStep6InitialState()) {
    on<ServiceCallReportStep6SubmitEvent>(_onSubmitEvent);
  }

  Future<void> _onSubmitEvent(
    ServiceCallReportStep6SubmitEvent event,
    Emitter<ServiceCallReportStep6State> emit,
  ) async {
    emit(ServiceCallReportStep6LoadingState());
    final result = await usecase(
      ServiceCallReportStep6Params(
        id: event.reportId,
        technicianRemarks: event.technicianRemarks,
        customerRemarks: event.customerRemarks,
        technicianRepresentative: event.technicianRepresentative,
        customerRepresentativeName: event.customerRepresentativeName,
        technicianSignaturePath: event.technicianSignaturePath,
        customerSignaturePath: event.customerSignaturePath,
        workPhotosPaths: event.workPhotosPaths,
      ),
    );
    result.fold(
      (Failure failure) =>
          emit(ServiceCallReportStep6FailureState(failure.message)),
      (data) => emit(ServiceCallReportStep6SuccessState(data)),
    );
  }
}
