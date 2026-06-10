import 'package:equatable/equatable.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/remote/repositories/repository_impl.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_report_step1_response.dart';

class PostAmcReportStep1Params extends Equatable {
  final String amcVisitId;
  final List<String> technicianIds;
  final String memberPresentsCustomerSide;
  final String agenda;

  const PostAmcReportStep1Params({
    required this.amcVisitId,
    required this.technicianIds,
    required this.memberPresentsCustomerSide,
    required this.agenda,
  });

  Map<String, dynamic> toJson() {
    return {
      "amc_visit_id": amcVisitId,
      "technician_ids": technicianIds,
      "member_presents_customer_side": memberPresentsCustomerSide,
      "agenda": agenda,
    };
  }

  @override
  List<Object?> get props => [
        amcVisitId,
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
      PostAmcReportStep1Params params) async {
    return await repository.amcReportStep1(params);
  }
}
