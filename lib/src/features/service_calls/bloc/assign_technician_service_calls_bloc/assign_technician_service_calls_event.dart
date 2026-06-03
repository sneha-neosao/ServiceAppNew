import 'package:equatable/equatable.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';

abstract class AssignTechnicianServiceCallsEvent extends Equatable {
  const AssignTechnicianServiceCallsEvent();

  @override
  List<Object?> get props => [];
}

class AssignTechnicianServiceCallsPostEvent
    extends AssignTechnicianServiceCallsEvent {
  final AssignTechnicianServiceCallsParams params;

  const AssignTechnicianServiceCallsPostEvent(this.params);

  @override
  List<Object?> get props => [params];
}
