import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/amc_visit_model/customer_amc_visits_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class CustomerAmcVisitsParams extends Equatable {
  final String customerId;
  final int page;
  final int pageSize;

  const CustomerAmcVisitsParams({
    required this.customerId,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object> get props => [customerId, page, pageSize];
}

class GetCustomerAmcVisitsUseCase
    extends UseCase<CustomerAmcVisitsResponse, CustomerAmcVisitsParams> {
  final Repository repository;

  GetCustomerAmcVisitsUseCase({required this.repository});

  @override
  Future<Either<Failure, CustomerAmcVisitsResponse>> call(
      CustomerAmcVisitsParams params) async {
    return await repository.getCustomerAmcVisits(params);
  }
}
