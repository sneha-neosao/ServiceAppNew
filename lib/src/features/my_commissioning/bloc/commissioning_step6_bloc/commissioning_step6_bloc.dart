import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecase/commissioning_step6_usecase.dart';
import 'commissioning_step6_event.dart';
import 'commissioning_step6_state.dart';

class CommissioningStep6Bloc
    extends Bloc<CommissioningStep6Event, CommissioningStep6State> {
  final CommissioningStep6Usecase usecase;

  CommissioningStep6Bloc(this.usecase)
    : super(CommissioningStep6InitialState()) {
    on<CommissioningStep6SubmitEvent>((event, emit) async {
      emit(CommissioningStep6LoadingState());

      final result = await usecase(
        CommissioningStep6Params(
          id: event.commissioning_report_id,
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
        (failure) {
          emit(CommissioningStep6FailureState(failure.message));
        },
        (success) {
          emit(CommissioningStep6SuccessState(success));
        },
      );
    });
  }
}
