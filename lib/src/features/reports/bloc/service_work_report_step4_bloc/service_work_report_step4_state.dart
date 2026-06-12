import 'package:equatable/equatable.dart';
import 'package:service_app/src/remote/models/service_work_report_step4_model/service_work_report_step4_response.dart';

abstract class ServiceWorkReportStep4State extends Equatable {
  const ServiceWorkReportStep4State();

  @override
  List<Object?> get props => [];
}

class ServiceWorkReportStep4Initial extends ServiceWorkReportStep4State {}

class ServiceWorkReportStep4Loading extends ServiceWorkReportStep4State {}

class ServiceWorkReportStep4Loaded extends ServiceWorkReportStep4State {
  final ServiceWorkReportStep4Response response;

  const ServiceWorkReportStep4Loaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ServiceWorkReportStep4Error extends ServiceWorkReportStep4State {
  final String message;

  const ServiceWorkReportStep4Error({required this.message});

  @override
  List<Object?> get props => [message];
}
