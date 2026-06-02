import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';

class CommissioningStep6Usecase implements UseCase<CommissioningReportStep6AutoFillResponse, CommissioningStep6Params> {
  final Repository _authRepository;

  const CommissioningStep6Usecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningReportStep6AutoFillResponse>> call(CommissioningStep6Params params) async {
    return await _authRepository.commissioning_report_step6(params);
  }
}

class CommissioningStep6Params extends Equatable {
  final String id;
  final String technicianRemarks;
  final String customerRemarks;
  final String technicianRepresentative;
  final String customerRepresentativeName;
  final String? technicianSignaturePath;
  final String? customerSignaturePath;
  final List<String> workPhotosPaths;

  const CommissioningStep6Params({
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
