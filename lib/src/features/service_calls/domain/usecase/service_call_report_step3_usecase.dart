import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/servicecall_report_step3_model/servicecall_report_step3_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart' show TechnicalDetails;

class ServiceCallReportStep3Params extends Equatable {
  final String id;
  final bool isTechnicalNa;
  final TechnicalDetails? technicalDetails;

  const ServiceCallReportStep3Params({
    required this.id,
    required this.isTechnicalNa,
    this.technicalDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_technical_na': isTechnicalNa,
      'technical_details': technicalDetails?.toJson() ?? {},
    };
  }

  @override
  List<Object?> get props => [
        id,
        isTechnicalNa,
        technicalDetails,
      ];
}

class ServiceCallReportStep3Usecase
    implements UseCase<ServiceCallStep3Response, ServiceCallReportStep3Params> {
  final AuthRepositoryImpl repository;
  ServiceCallReportStep3Usecase(this.repository);

  @override
  Future<Either<Failure, ServiceCallStep3Response>> call(
      ServiceCallReportStep3Params params) async {
    return await repository.serviceCallReportStep3(params);
  }
}
