import 'package:equatable/equatable.dart';

sealed class CommissioningWorkUpdateEvent extends Equatable {
  const CommissioningWorkUpdateEvent();

  @override
  List<Object?> get props => [];
}

class CommissioningWorkUpdateSubmitEvent extends CommissioningWorkUpdateEvent {
  final String workId;
  final String customerId;
  final String siteId;
  final String applicationOfEquipment;
  final List<String> technicians;

  const CommissioningWorkUpdateSubmitEvent({
    required this.workId,
    required this.customerId,
    required this.siteId,
    required this.applicationOfEquipment,
    required this.technicians,
  });

  @override
  List<Object?> get props => [
    workId,
    customerId,
    siteId,
    applicationOfEquipment,
    technicians,
  ];
}
