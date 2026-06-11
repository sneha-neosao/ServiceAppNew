import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_pdf_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class GetAmcReportPdfUseCase implements UseCase<AmcReportPdfResponse, String> {
  final Repository repository;

  GetAmcReportPdfUseCase(this.repository);

  @override
  Future<Either<Failure, AmcReportPdfResponse>> call(String reportId) async {
    return await repository.getAmcReportPdf(reportId);
  }
}
