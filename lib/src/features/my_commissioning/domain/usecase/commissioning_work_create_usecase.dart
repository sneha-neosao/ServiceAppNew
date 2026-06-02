import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_work_create_model/commissioning_work_create_response.dart';

/// Use case for creating a new Commissioning Work entry via API.
class CommissioningWorkCreateUseCase
    implements
        UseCase<
          CommissioningWorkCreateResponse,
          CommissioningWorkCreateParams
        > {
  final Repository _authRepository;
  const CommissioningWorkCreateUseCase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningWorkCreateResponse>> call(
    CommissioningWorkCreateParams params,
  ) async {
    if (params.customerId.isEmpty) {
      return Left(EmptyFailure("Please select a customer"));
    }
    if (params.siteId.isEmpty) {
      return Left(EmptyFailure("Please select a site"));
    }
    if (params.applicationOfEquipment.isEmpty) {
      return Left(EmptyFailure("Please enter application of equipment"));
    }
    if (params.technicians.isEmpty ||
        params.technicians.any((t) => t.isEmpty)) {
      return Left(EmptyFailure("Please select a technician"));
    }

    final result = await _authRepository.commissioningWorkCreate(params);
    return result;
  }
}

class CommissioningWorkCreateParams extends Equatable {
  final String customerId;
  final String siteId;
  final String applicationOfEquipment;
  final List<String> technicians;

  const CommissioningWorkCreateParams({
    required this.customerId,
    required this.siteId,
    required this.applicationOfEquipment,
    required this.technicians,
  });

  @override
  List<Object?> get props => [
    customerId,
    siteId,
    applicationOfEquipment,
    technicians,
  ];

  factory CommissioningWorkCreateParams.fromJson(Map<String, dynamic> json) {
    return CommissioningWorkCreateParams(
      customerId: json['customer_id'],
      siteId: json['site_id'],
      applicationOfEquipment: json['application_of_equipment'],
      technicians: List<String>.from(json['technicians']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'site_id': siteId,
      'application_of_equipment': applicationOfEquipment,
      'technicians': technicians,
    };
  }
}
