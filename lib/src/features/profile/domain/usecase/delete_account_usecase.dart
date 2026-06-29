import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/delete_account_model/delete_account_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class DeleteAccountUseCase implements UseCase<DeleteAccountResponse, NoParams> {
  final Repository _authRepository;

  const DeleteAccountUseCase(this._authRepository);

  @override
  Future<Either<Failure, DeleteAccountResponse>> call(NoParams params) async {
    final result = await _authRepository.deleteAccount();

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
