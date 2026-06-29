import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_work_report_step4_model/service_work_report_step4_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceWorkReportStep4Params extends Equatable {
  final String id;
  final String customerRepresentativeName;
  final String customerRemarks;
  final String technicianRemarks;
  final String technicianRepresentative;
  final String qrCodeUrl;
  final List<String> workPhotosPaths;
  final String? customerSignaturePath;
  final String? technicianSignaturePath;

  const ServiceWorkReportStep4Params({
    required this.id,
    required this.customerRepresentativeName,
    required this.customerRemarks,
    required this.technicianRemarks,
    required this.technicianRepresentative,
    this.qrCodeUrl = '',
    required this.workPhotosPaths,
    this.customerSignaturePath,
    this.technicianSignaturePath,
  });

  @override
  List<Object?> get props => [
        id,
        customerRepresentativeName,
        customerRemarks,
        technicianRemarks,
        technicianRepresentative,
        qrCodeUrl,
        workPhotosPaths,
        customerSignaturePath,
        technicianSignaturePath,
      ];
}

class ServiceWorkReportStep4Usecase
    implements
        UseCase<ServiceWorkReportStep4Response, ServiceWorkReportStep4Params> {
  final AuthRepositoryImpl repository;

  ServiceWorkReportStep4Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceWorkReportStep4Response>> call(
    ServiceWorkReportStep4Params params,
  ) async {
    return await repository.serviceWorkReportStep4(params);
  }
}
