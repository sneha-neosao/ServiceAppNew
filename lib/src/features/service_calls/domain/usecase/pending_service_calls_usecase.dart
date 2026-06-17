import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/service_calls_model/pending_serbice_calls_response.dart';

class PendingServiceCallsParams extends Equatable {
  final int page;
  final int pageSize;
  final String? customerId;
  final String? siteId;
  final String? customerName;
  final String? siteName;
  final String? complaintNumber;
  final String? date;

  const PendingServiceCallsParams({
    required this.page,
    required this.pageSize,
    this.customerId,
    this.siteId,
    this.customerName,
    this.siteName,
    this.complaintNumber,
    this.date,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'page': page, 'page_size': pageSize};
    if (customerId != null && customerId!.isNotEmpty) {
      map['customer_id'] = customerId;
    }
    if (siteId != null && siteId!.isNotEmpty) {
      map['site_id'] = siteId;
    }
    if (customerName != null && customerName!.isNotEmpty) {
      map['customer_name'] = customerName;
    }
    if (siteName != null && siteName!.isNotEmpty) {
      map['site_name'] = siteName;
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
  List<Object?> get props => [
    page,
    pageSize,
    customerId,
    siteId,
    customerName,
    siteName,
    complaintNumber,
    date,
  ];
}

class PendingServiceCallsUseCase
    implements UseCase<PendingServiceCallsResponse, PendingServiceCallsParams> {
  final Repository _repository;

  const PendingServiceCallsUseCase(this._repository);

  @override
  Future<Either<Failure, PendingServiceCallsResponse>> call(
    PendingServiceCallsParams params,
  ) async {
    return await _repository.pendingServiceCalls(params);
  }
}
