import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/errors/failures.dart';
import 'package:service_app/src/core/usecases/usecase.dart';
import 'package:service_app/src/remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_response.dart';

/// Domain layer use case for verifying user and CommissioningStep2

class CommissioningStep2Usecase
    implements UseCase<CommissioningStep2Response, CommissioningStep2Params> {
  final Repository _authRepository;
  const CommissioningStep2Usecase(this._authRepository);

  @override
  Future<Either<Failure, CommissioningStep2Response>> call(
    CommissioningStep2Params params,
  ) async {
    final result = await _authRepository.commissioning_report_step2(params);

    return result;
  }
}

class CommissioningStep2Params extends Equatable {
  final String id;
  final int warrantyPeriodYears;
  final List<String> memberPresentsCustomerSide;
  final String agenda;

  const CommissioningStep2Params({
    required this.id,
    required this.warrantyPeriodYears,
    required this.memberPresentsCustomerSide,
    required this.agenda,
  });

  @override
  List<Object?> get props => [
    id,
    warrantyPeriodYears,
    memberPresentsCustomerSide,
    agenda,
  ];

  factory CommissioningStep2Params.fromJson(Map<String, dynamic> json) {
    return CommissioningStep2Params(
      id: json['id'],
      warrantyPeriodYears: json['warranty_period_years'],
      memberPresentsCustomerSide: List<String>.from(
        json['member_presents_customer_side'],
      ),
      agenda: json['agenda'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'warranty_period_years': warrantyPeriodYears,
      'member_presents_customer_side': memberPresentsCustomerSide,
      'agenda': agenda,
    };
  }
}
