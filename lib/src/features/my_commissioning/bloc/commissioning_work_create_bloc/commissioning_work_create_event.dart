part of 'commissioning_work_create_bloc.dart';

sealed class CommissioningWorkCreateEvent extends Equatable {
  const CommissioningWorkCreateEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkCreateSubmitEvent extends CommissioningWorkCreateEvent {
  final String customerId;
  final String siteId;
  final String applicationOfEquipment;
  final List<String> technicians;

  const CommissioningWorkCreateSubmitEvent({
    required this.customerId,
    required this.siteId,
    required this.applicationOfEquipment,
    required this.technicians,
  });

  @override
  List<Object?> get props => [
    customerId,
    siteId,
    applicationOfEquipment,
    technicians,
  ];
}
