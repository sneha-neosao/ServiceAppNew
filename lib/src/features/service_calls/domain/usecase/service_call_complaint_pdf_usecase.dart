import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_complaint_pdf_model/servicecall_complaint_pdf_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallComplaintPdfUseCase
    implements UseCase<ServiceCallComplaintPdfResponse, String> {
  final Repository repository;

  ServiceCallComplaintPdfUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceCallComplaintPdfResponse>> call(
    String complaintId,
  ) async {
    return await repository.getServiceCallComplaintPdf(complaintId);
  }
}
