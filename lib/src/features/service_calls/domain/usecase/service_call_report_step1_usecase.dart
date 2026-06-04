import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step1_model/servicecall_report_step1_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep1Params extends Equatable {
  final String complaintId;
  final List<String> technicianIds;

  const ServiceCallReportStep1Params({
    required this.complaintId,
    required this.technicianIds,
  });

  Map<String, dynamic> toJson() {
    return {'complaint_id': complaintId, 'technician_ids': technicianIds};
  }

  @override
  List<Object?> get props => [complaintId, technicianIds];
}

class ServiceCallReportStep1Usecase
    implements UseCase<ServiceCallStep1Response, ServiceCallReportStep1Params> {
  final AuthRepositoryImpl repository;

  ServiceCallReportStep1Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep1Response>> call(
    ServiceCallReportStep1Params params,
  ) async {
    return await repository.serviceCallReportStep1(params);
  }
}
