import 'dart:io';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step3_response.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class PostAmcReportStep3UseCase
    implements UseCase<AmcReportStep3Response, PostAmcReportStep3Params> {
  final Repository repository;

  PostAmcReportStep3UseCase(this.repository);

  @override
  Future<Either<Failure, AmcReportStep3Response>> call(
    PostAmcReportStep3Params params,
  ) async {
    return repository.amcReportStep3(params);
  }
}

class PostAmcReportStep3Params {
  final String id;
  final String technicianRemarks;
  final String customerRemarks;
  final List<File> workPhotos;
  final String technicianRepresentative;
  final File? technicianSignature;
  final String customerRepresentativeName;
  final File? customerSignature;

  PostAmcReportStep3Params({
    required this.id,
    required this.technicianRemarks,
    required this.customerRemarks,
    required this.workPhotos,
    required this.technicianRepresentative,
    this.technicianSignature,
    required this.customerRepresentativeName,
    this.customerSignature,
  });
}
