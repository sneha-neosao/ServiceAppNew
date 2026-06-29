import 'package:equatable/equatable.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step1_response.dart';

class PostAmcReportStep1Params extends Equatable {
  final String amcVisitId;
  final String? amcReportId;
  final List<Map<String, dynamic>> technicianIds;
  final String memberPresentsCustomerSide;
  final String agenda;

  const PostAmcReportStep1Params({
    required this.amcVisitId,
    this.amcReportId,
    required this.technicianIds,
    required this.memberPresentsCustomerSide,
    required this.agenda,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "amc_visit_id": amcVisitId,
      "technician_ids": technicianIds,
      "member_presents_customer_side": memberPresentsCustomerSide,
      "agenda": agenda,
    };
    if (amcReportId != null && amcReportId!.isNotEmpty) {
      data["amc_report_id"] = amcReportId;
    }
    return data;
  }

  @override
  List<Object?> get props => [
    amcVisitId,
    amcReportId,
    technicianIds,
    memberPresentsCustomerSide,
    agenda,
  ];
}

class PostAmcReportStep1Usecase
    implements UseCase<AmcReportStep1Response, PostAmcReportStep1Params> {
  final Repository repository;

  PostAmcReportStep1Usecase(this.repository);

  @override
  Future<Either<Failure, AmcReportStep1Response>> call(
    PostAmcReportStep1Params params,
  ) async {
    return await repository.amcReportStep1(params);
  }
}
