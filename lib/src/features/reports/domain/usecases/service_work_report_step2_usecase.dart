import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step2_model/service_work_report_step2_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep2Params extends Equatable {
  final String id;
  final bool isTechnicalNa;
  final String technicalDetails;
  final List<Map<String, dynamic>> descriptions;

  const ServiceWorkReportStep2Params({
    required this.id,
    required this.isTechnicalNa,
    required this.technicalDetails,
    required this.descriptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_technical_na': isTechnicalNa,
      'technical_details': technicalDetails,
      'descriptions': descriptions,
    };
  }

  @override
  List<Object?> get props => [
        id,
        isTechnicalNa,
        technicalDetails,
        descriptions,
      ];
}

class ServiceWorkReportStep2Usecase
    implements UseCase<ServiceWorkReportStep2Response, ServiceWorkReportStep2Params> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep2Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep2Response>> call(
    ServiceWorkReportStep2Params params,
  ) async {
    return await repository.serviceWorkReportStep2(params);
  }
}
