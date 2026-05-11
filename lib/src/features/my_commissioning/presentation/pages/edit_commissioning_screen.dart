import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class EditCommissioningScreen extends StatelessWidget {
  final VoidCallback onBack;
  final String customerName;
  final String siteLocation;
  final String assignedTechnicians;

  const EditCommissioningScreen({
    super.key,
    required this.onBack,
    required this.customerName,
    required this.siteLocation,
    required this.assignedTechnicians,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title Section ─────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'edit_commissioning_title'.tr(),
                    style: AppFont.style(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  Text(
                    'edit_commissioning_subtitle'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Step 1: Customer ──────────────────────────────────────────────
          _buildStepHeader('edit_commissioning_step1'.tr()),
          _buildDropdownField(customerName),

          const SizedBox(height: 24),

          // ── Step 2: Site ──────────────────────────────────────────────────
          _buildStepHeader('edit_commissioning_step2'.tr()),
          _buildDropdownField(siteLocation),

          const SizedBox(height: 24),

          // ── Step 3: Equipment ─────────────────────────────────────────────
          _buildStepHeader('edit_commissioning_step3'.tr()),
          _buildDisplayField('HVAC Cooling'),

          const SizedBox(height: 24),

          // ── Step 4: Technicians ───────────────────────────────────────────
          _buildStepHeader('edit_commissioning_step4'.tr()),
          _buildDropdownField(assignedTechnicians),

          const SizedBox(height: 40),

          // ── Assign Button ─────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'edit_commissioning_btn_assign'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppFont.style(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA5ABB7),
              letterSpacing: 0.5,
            ),
          ),
          if (title.contains('CUSTOMER') || title.contains('SITE'))
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.add, size: 16, color: Color(0xFF1565C0)),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String value) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D121F),
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
        ],
      ),
    );
  }

  Widget _buildDisplayField(String value) {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Text(
        value,
        style: AppFont.style(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF0D121F),
        ),
      ),
    );
  }
}
