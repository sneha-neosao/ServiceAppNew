import 'package:equatable/equatable.dart';

sealed class CommissioningStep6Event extends Equatable {
  const CommissioningStep6Event();

  @override
  List<Object?> get props => [];
}

class CommissioningStep6SubmitEvent extends CommissioningStep6Event {
  final String commissioning_report_id;
  final String? assignId;
  final String technicianRemarks;
  final String customerRemarks;
  final String technicianRepresentative;
  final String customerRepresentativeName;
  final String? technicianSignaturePath;
  final String? customerSignaturePath;
  final List<String> workPhotosPaths;

  const CommissioningStep6SubmitEvent({
    required this.commissioning_report_id,
    this.assignId,
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
    commissioning_report_id,
    assignId,
    technicianRemarks,
    customerRemarks,
    technicianRepresentative,
    customerRepresentativeName,
    technicianSignaturePath,
    customerSignaturePath,
    workPhotosPaths,
  ];
}
