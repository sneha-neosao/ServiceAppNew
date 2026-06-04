import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step1_model/commissioning_report_step1_response.dart';

/// Domain layer use case for verifying user and CommissioningStep1Response

class CommissioningStep1Usecase
    implements UseCase<CommissioningStep1Response, CommissioningStep1Params> {
  final Repository _authRepository;
  const CommissioningStep1Usecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningStep1Response>> call(
    CommissioningStep1Params params,
  ) async {
    final result = await _authRepository.commissioning_report_step1(params);

    return result;
  }
}

class CommissioningStep1Params extends Equatable {
  final String commissioningWorkId;
  final List<String> technicianIds;

  const CommissioningStep1Params({
    required this.commissioningWorkId,
    required this.technicianIds,
  });

  @override
  List<Object?> get props => [commissioningWorkId, technicianIds];

  factory CommissioningStep1Params.fromJson(Map<String, dynamic> json) {
    return CommissioningStep1Params(
      commissioningWorkId: json['commissioning_work_id'],
      technicianIds: List<String>.from(json['technician_ids']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commissioning_work_id': commissioningWorkId,
      'technician_ids': technicianIds,
    };
  }
}
