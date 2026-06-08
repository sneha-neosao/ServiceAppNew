import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_calls_details_model/service_calls_details_response.dart';

class ServiceCallDetailsUseCase
    implements UseCase<ServiceCallDetailsResponse, String> {
  final Repository _repository;

  const ServiceCallDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, ServiceCallDetailsResponse>> call(
    String params,
  ) async {
    return await _repository.serviceCallDetails(params);
  }
}
