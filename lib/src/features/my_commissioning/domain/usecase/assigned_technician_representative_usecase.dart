import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/assigned_technician_representative_model/assigned_technician_representative_response.dart';

class AssignedTechnicianRepresentativeUsecase implements UseCase<AssignedTechnicianResponse, AssignedTechnicianRepresentativeParams> {
  final Repository _authRepository;

  const AssignedTechnicianRepresentativeUsecase(this._authRepository);

  @override
  Future<Either<Failure, AssignedTechnicianResponse>> call(AssignedTechnicianRepresentativeParams params) async {
    return await _authRepository.assigned_technician_representative(params);
  }
}

class AssignedTechnicianRepresentativeParams extends Equatable {
  final String id;

  const AssignedTechnicianRepresentativeParams(
    this.id,
  );

  @override
  List<Object?> get props => [
        id,
      ];
}
