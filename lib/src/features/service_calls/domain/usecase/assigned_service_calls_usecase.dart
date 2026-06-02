import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_calls_model/assigned_service_calls_response.dart';

class AssignedServiceCallsParams extends Equatable {
  final int page;
  final int pageSize;
  final String? customerId;
  final String? siteId;
  final String? complaintNumber;
  final String? date;

  const AssignedServiceCallsParams({
    required this.page,
    required this.pageSize,
    this.customerId,
    this.siteId,
    this.complaintNumber,
    this.date,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (customerId != null && customerId!.isNotEmpty) {
      map['customer_id'] = customerId;
    }
    if (siteId != null && siteId!.isNotEmpty) {
      map['site_id'] = siteId;
    }
    if (complaintNumber != null && complaintNumber!.isNotEmpty) {
      map['complaint_number'] = complaintNumber;
    }
    if (date != null && date!.isNotEmpty) {
      map['date'] = date;
    }
    return map;
  }

  @override
  List<Object?> get props => [page, pageSize, customerId, siteId, complaintNumber, date];
}

class AssignedServiceCallsUseCase implements UseCase<AssignedServiceCallsResponse, AssignedServiceCallsParams> {
  final Repository _repository;

  const AssignedServiceCallsUseCase(this._repository);

  @override
  Future<Either<Failure, AssignedServiceCallsResponse>> call(AssignedServiceCallsParams params) async {
    return await _repository.assignedServiceCalls(params);
  }
}
