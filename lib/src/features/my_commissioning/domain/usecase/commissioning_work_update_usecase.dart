import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/remote/models/commissioning_work_create_model/commissioning_work_create_response.dart';

class CommissioningWorkUpdateUseCase {
  final Repository _repository;

  const CommissioningWorkUpdateUseCase(this._repository);

  Future<Either<Failure, CommissioningWorkCreateResponse>> call(
    CommissioningWorkUpdateParams params,
    String workId,
  ) async {
    final result = await _repository.commissioningWorkUpdate(params, workId);
    return result;
  }
}

class CommissioningWorkUpdateParams extends Equatable {
  final String customerId;
  final String siteId;
  final String applicationOfEquipment;
  final List<String> technicians;

  const CommissioningWorkUpdateParams({
    required this.customerId,
    required this.siteId,
    required this.applicationOfEquipment,
    required this.technicians,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'site_id': siteId,
      'application_of_equipment': applicationOfEquipment,
      'technicians': technicians,
    };
  }

  @override
  List<Object?> get props => [
        customerId,
        siteId,
        applicationOfEquipment,
        technicians,
      ];
}
