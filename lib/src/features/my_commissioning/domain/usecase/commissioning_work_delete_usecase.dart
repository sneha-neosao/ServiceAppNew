import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';

class CommissioningWorkDeleteUseCase {
  final Repository _repository;

  const CommissioningWorkDeleteUseCase(this._repository);

  Future<Either<Failure, String>> call(String workId) async {
    return await _repository.commissioningWorkDelete(workId);
  }
}
