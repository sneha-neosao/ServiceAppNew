import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_details_usecase.dart';
import 'service_call_details_event.dart';
import 'service_call_details_state.dart';

class ServiceCallDetailsBloc
    extends Bloc<ServiceCallDetailsEvent, ServiceCallDetailsState> {
  final ServiceCallDetailsUseCase _useCase;

  ServiceCallDetailsBloc(this._useCase) : super(ServiceCallDetailsInitialState()) {
    on<ServiceCallDetailsGetEvent>(_onGetServiceCallDetails);
  }

  Future<void> _onGetServiceCallDetails(
    ServiceCallDetailsGetEvent event,
    Emitter<ServiceCallDetailsState> emit,
  ) async {
    emit(ServiceCallDetailsLoadingState());
    final result = await _useCase(event.id);
    result.fold(
      (failure) => emit(ServiceCallDetailsFailureState(failure.message)),
      (data) => emit(ServiceCallDetailsSuccessState(data)),
    );
  }
}
