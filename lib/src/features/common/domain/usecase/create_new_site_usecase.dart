import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/create_new_site_model/create_new_site_response.dart';

class CreateNewSiteUsecase
    implements UseCase<AddSiteResponse, CreateNewSiteParams> {
  final Repository _repository;

  const CreateNewSiteUsecase(this._repository);

  @override
  Future<Either<Failure, AddSiteResponse>> call(
    CreateNewSiteParams params,
  ) async {
    return await _repository.createNewSite(params);
  }
}

class CreateNewSiteParams extends Equatable {
  final String customerId;
  final String customerName;
  final String siteName;

  const CreateNewSiteParams({
    required this.customerId,
    required this.customerName,
    required this.siteName,
  });

  @override
  List<Object?> get props => [customerId, customerName, siteName];
}
