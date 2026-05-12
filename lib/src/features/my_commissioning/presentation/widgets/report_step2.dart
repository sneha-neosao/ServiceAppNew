import 'package:flutter/material.dart';
import 'package:service_app/src/features/my_commissioning/presentation/widgets/report_form_widgets.dart';

class Step2EquipmentDetails extends StatelessWidget {
  const Step2EquipmentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportLabel(text: 'EQUIPMENT TYPE'),
        const ReportDropdownField(hint: 'Centrifugal Chiller'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'MODEL NUMBER'),
        const ReportTextField(hint: 'CVHE-050'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'SERIAL NUMBER'),
        const ReportTextField(hint: 'L12J12345'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'CAPACITY (TR)'),
        const ReportTextField(hint: '500'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'REFRIGERANT'),
        const ReportDropdownField(hint: 'R-123'),
      ],
    );
  }
}
