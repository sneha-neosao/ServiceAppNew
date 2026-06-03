import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step6_model/servicecall_report_step6_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportStep6Usecase
    implements UseCase<ServiceCallStep6Response, ServiceCallReportStep6Params> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep6Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep6Response>> call(
      ServiceCallReportStep6Params params) async {
    return await repository.serviceCallReportStep6(params);
  }
}

class ServiceCallReportStep6Params extends Equatable {
  final String id;
  final String technicianRemarks;
  final String customerRemarks;
  final String technicianRepresentative;
  final String customerRepresentativeName;
  final String? technicianSignaturePath;
  final String? customerSignaturePath;
  final List<String> workPhotosPaths;

  const ServiceCallReportStep6Params({
    required this.id,
    required this.technicianRemarks,
    required this.customerRemarks,
    required this.technicianRepresentative,
    required this.customerRepresentativeName,
    this.technicianSignaturePath,
    this.customerSignaturePath,
    required this.workPhotosPaths,
  });

  @override
  List<Object?> get props => [
        id,
        technicianRemarks,
        customerRemarks,
        technicianRepresentative,
        customerRepresentativeName,
        technicianSignaturePath,
        customerSignaturePath,
        workPhotosPaths,
      ];
}
