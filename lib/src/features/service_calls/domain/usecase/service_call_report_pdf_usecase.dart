import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_history_model/commissioning_report_pdf_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class ServiceCallReportPdfUseCase
    implements UseCase<CommissioningReportPdfResponse, String> {
  final Repository repository;

  ServiceCallReportPdfUseCase(this.repository);

  @override
  Future<Either<Failure, CommissioningReportPdfResponse>> call(
    String reportId,
  ) async {
    return await repository.getServiceCallReportPdf(reportId);
  }
}
