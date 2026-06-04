import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/create_new_customer_model/create_new_customer_response.dart';

class CreateNewCustomerUsecase implements UseCase<AddCustomerResponse, CreateNewCustomerParams> {
  final Repository _repository;

  const CreateNewCustomerUsecase(this._repository);

  @override
  Future<Either<Failure, AddCustomerResponse>> call(CreateNewCustomerParams params) async {
    return await _repository.createNewCustomer(params);
  }
}

class CreateNewCustomerParams extends Equatable {
  final String name;
  final bool mergeExisting;
  final List<dynamic> sites;

  const CreateNewCustomerParams({
    required this.name,
    this.mergeExisting = false,
    this.sites = const [],
  });

  @override
  List<Object?> get props => [name, mergeExisting, sites];
}
