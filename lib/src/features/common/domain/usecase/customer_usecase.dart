import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/auth_model/Login_response.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';

/// Domain layer use case for fetching customers

class CustomerParams extends Equatable {
  final int page;
  final int pageSize;
  final String search;

  const CustomerParams({
    this.page = 1,
    this.pageSize = 100,
    this.search = '',
  });

  @override
  List<Object> get props => [page, pageSize, search];
}

class CustomerUseCase implements UseCase<CustomerResponse, CustomerParams> {
  final Repository _authRepository;
  const CustomerUseCase(this._authRepository);

  @override
  Future<Either<Failure, CustomerResponse>> call(CustomerParams params) async {
    final result = await _authRepository.customers(params);

    return result;
  }
}
