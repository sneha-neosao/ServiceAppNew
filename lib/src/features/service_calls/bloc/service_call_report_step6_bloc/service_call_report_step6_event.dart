import 'package:equatable/equatable.dart';

abstract class ServiceCallReportStep6Event extends Equatable {
  const ServiceCallReportStep6Event();

  @override
  List<Object?> get props => [];
}

class ServiceCallReportStep6SubmitEvent extends ServiceCallReportStep6Event {
  final String reportId;
  final String technicianRemarks;
  final String customerRemarks;
  final String technicianRepresentative;
  final String customerRepresentativeName;
  final String? technicianSignaturePath;
  final String? customerSignaturePath;
  final List<String> workPhotosPaths;

  const ServiceCallReportStep6SubmitEvent({
    required this.reportId,
    required this.technicianRemarks,
    required this.customerRemarks,
    required this.technicianRepresentative,
    required this.customerRepresentativeName,
    this.technicianSignaturePath,
    this.customerSignaturePath,
    required this.workPhotosPaths,
  });

  @override
  List<Object?> get props => [
        reportId,
        technicianRemarks,
        customerRemarks,
        technicianRepresentative,
        customerRepresentativeName,
        technicianSignaturePath,
        customerSignaturePath,
        workPhotosPaths,
      ];
}
