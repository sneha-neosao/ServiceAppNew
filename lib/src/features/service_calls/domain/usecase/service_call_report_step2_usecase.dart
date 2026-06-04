import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step2_model/servicecall_report_step2_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep2Params extends Equatable {
  final String id;
  final String memberPresentsCustomerSide;
  final String agenda;

  const ServiceCallReportStep2Params({
    required this.id,
    required this.memberPresentsCustomerSide,
    required this.agenda,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_presents_customer_side': memberPresentsCustomerSide,
      'agenda': agenda,
    };
  }

  @override
  List<Object?> get props => [id, memberPresentsCustomerSide, agenda];
}

class ServiceCallReportStep2Usecase
    implements UseCase<ServiceCallStep2Response, ServiceCallReportStep2Params> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep2Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep2Response>> call(
    ServiceCallReportStep2Params params,
  ) async {
    return await repository.serviceCallReportStep2(params);
  }
}
