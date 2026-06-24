import 'package:fpdart/fpdart.dart';

import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/amc_visit_model/customer_amc_visits_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetCustomerAmcVisitsUseCase
    extends UseCase<CustomerAmcVisitsResponse, String> {
  final Repository repository;

  GetCustomerAmcVisitsUseCase({required this.repository});

  @override
  Future<Either<Failure, CustomerAmcVisitsResponse>> call(
      String params) async {
    return await repository.getCustomerAmcVisits(params);
  }
}
