part of 'commissioning_step2_bloc.dart';

/// Event for authentication related information.

sealed class CommissioningStep2Event extends Equatable {
  const CommissioningStep2Event();

  @override
  List<Object?> get props => [];
}

/// Event for CommissioningStep2 submit.

class CommissioningStep2GetEvent extends CommissioningStep2Event {

  final String id;
  final int warrantyPeriodYears;
  final List<String> memberPresentsCustomerSide;
  final String agenda;

  const CommissioningStep2GetEvent(
       this.id,
       this.warrantyPeriodYears,
       this.memberPresentsCustomerSide,
       this.agenda,);

  @override
  List<Object?> get props => [
    id,
    warrantyPeriodYears,
    memberPresentsCustomerSide,
    agenda,];
}
