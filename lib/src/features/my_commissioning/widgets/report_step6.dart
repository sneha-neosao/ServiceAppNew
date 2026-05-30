import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/widgets/report_form_widgets.dart';

class Step6Declaration extends StatelessWidget {
  const Step6Declaration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Remarks Section ──────────────────────────────────────────────
        const ReportLabel(text: 'REMARKS (TECHNICIAN)'),
        const SizedBox(height: 12),
        const ReportRemarksBox(placeholder: 'Technician side remarks...'),

        const SizedBox(height: 24),

        const ReportLabel(text: 'REMARKS (CUSTOMER)'),
        const SizedBox(height: 12),
        const ReportRemarksBox(placeholder: 'Customer side remarks...'),

        const SizedBox(height: 32),

        // ── Photos Section ──────────────────────────────────────────────
        const ReportLabel(text: 'Photos'),
        const SizedBox(height: 16),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, color: Color(0xFFA5ABB7), size: 32),
              const SizedBox(height: 8),
              Text(
                'ADD',
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // ── Recorded By Section ─────────────────────────────────────────
        Text(
          'Recorded By:',
          style: AppFont.style(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),

        // ── Technician Rep ─────────────────────────────────────────────
        const ReportLabel(text: 'Technician Rep'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        const ReportInfoRow(label: 'Name', value: 'Vinod Patil'),
        const SizedBox(height: 24),
        const ReportInfoRow(label: 'Date', value: '12/05/2026'),
        const SizedBox(height: 24),
        const ReportSignatureRow(label: 'Sign', placeholder: 'Digitally Signed'),

        const SizedBox(height: 40),

        // ── Customer Rep ───────────────────────────────────────────────
        const ReportLabel(text: 'Customer Rep'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        const ReportLabel(text: 'Name'),
        const ReportTextField(hint: 'Enter customer representative name'),
        const SizedBox(height: 24),
        const ReportInfoRow(label: 'Date', value: '12/05/2026'),
        const SizedBox(height: 24),
        const ReportSignatureRow(label: 'Sign', placeholder: 'Signature Area'),

        const SizedBox(height: 40),
      ],
    );
  }
}

class ReportSignatureRow extends StatelessWidget {
  final String label;
  final String placeholder;

  const ReportSignatureRow({super.key, required this.label, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
        ),
        Text(
          ':',
          style: AppFont.style(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFF1F2F6)),
            ),
            child: Center(
              child: Text(
                placeholder,
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
