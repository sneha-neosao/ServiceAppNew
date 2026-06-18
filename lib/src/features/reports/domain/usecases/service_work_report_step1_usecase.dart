import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step1_model/service_work_report_step1_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep1Params extends Equatable {
  final String customerId;
  final String siteId;
  final List<Map<String, String>> technicianIds;
  final String memberPresentsCustomerSide;
  final String agenda;
  final String? complaintId;

  const ServiceWorkReportStep1Params({
    required this.customerId,
    required this.siteId,
    required this.technicianIds,
    required this.memberPresentsCustomerSide,
    required this.agenda,
    this.complaintId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'customer_id': customerId,
      'site_id': siteId,
      'technician_ids': technicianIds,
      'member_presents_customer_side': memberPresentsCustomerSide,
      'agenda': agenda,
    };
    if (complaintId != null && complaintId!.isNotEmpty) {
      data['complaint_id'] = complaintId;
    }
    return data;
  }

  @override
  List<Object?> get props => [
        customerId,
        siteId,
        technicianIds,
        memberPresentsCustomerSide,
        agenda,
        complaintId,
      ];
}

class ServiceWorkReportStep1Usecase
    implements UseCase<ServiceWorkReportStep1Response, ServiceWorkReportStep1Params> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep1Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep1Response>> call(
    ServiceWorkReportStep1Params params,
  ) async {
    return await repository.serviceWorkReportStep1(params);
  }
}
