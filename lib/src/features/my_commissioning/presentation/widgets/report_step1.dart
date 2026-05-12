import 'package:flutter/material.dart';
import 'package:service_app/src/features/my_commissioning/presentation/widgets/report_form_widgets.dart';

class Step1GeneralInfo extends StatelessWidget {
  const Step1GeneralInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportLabel(text: 'CLIENT NAME'),
        const ReportTextField(hint: 'Reliance Mart'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'SITE NAME'),
        const ReportTextField(hint: 'Chiller Plant'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'CONTACT PERSON'),
        const ReportTextField(hint: 'Rahul Deshmukh'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'PHONE NUMBER'),
        const ReportTextField(hint: '+91 98765 43210'),
        const SizedBox(height: 24),
        const ReportLabel(text: 'EMAIL ID'),
        const ReportTextField(hint: 'rahul@reliance.com'),
      ],
    );
  }
}
