import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/features/profile/domain/usecase/delete_account_usecase.dart';
import 'delete_account_event.dart';
import 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountBloc(this._deleteAccountUseCase)
    : super(DeleteAccountInitialState()) {
    on<DeleteAccountSubmittedEvent>(_onDeleteAccountSubmitted);
  }

  Future<void> _onDeleteAccountSubmitted(
    DeleteAccountSubmittedEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(DeleteAccountLoadingState());
    final result = await _deleteAccountUseCase.call(NoParams());
    result.fold(
      (failure) => emit(DeleteAccountFailureState(failure.message)),
      (data) => emit(DeleteAccountSuccessState(data)),
    );
  }
}
