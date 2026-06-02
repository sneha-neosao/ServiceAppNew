import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/commissioning_work_model/commissioning_work_details_response.dart';

class CommissioningWorkDetailsUseCase {
  final Repository _repository;
  const CommissioningWorkDetailsUseCase(this._repository);

  Future<Either<Failure, CommissioningWorkDetailsResponse>> call(
    String workId,
  ) async {
    final result = await _repository.commissioningWorkDetails(workId);
    return result;
  }
}
