import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/close_over_call_model/close_over_call_response.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';

class CloseOverCallParams extends Equatable {
  final String complaintId;
  final String serviceCallDetails;
  final String customerId;
  final String siteId;

  const CloseOverCallParams({
    required this.complaintId,
    required this.serviceCallDetails,
    required this.customerId,
    required this.siteId,
  });

  Map<String, dynamic> toMap() {
    return {
      'complaint_id': complaintId,
      'service_call_details': serviceCallDetails,
      'customer_id': customerId,
      'site_id': siteId,
    };
  }

  @override
  List<Object?> get props => [
    complaintId,
    serviceCallDetails,
    customerId,
    siteId,
  ];
}

class CloseOverCallUsecase
    implements UseCase<CloseOverCallResponse, CloseOverCallParams> {
  final Repository repository;

  CloseOverCallUsecase(this.repository);

  @override
  Future<Either<Failure, CloseOverCallResponse>> call(
    CloseOverCallParams params,
  ) async {
    return await repository.closeOverCall(params);
  }
}
