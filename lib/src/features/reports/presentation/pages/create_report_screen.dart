import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class CreateReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  const CreateReportScreen({super.key, required this.onBack});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  int _currentStep = 1;

  void _nextStep() {
    if (_currentStep < 6) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Progress & Header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFA5ABB7)),
                      onPressed: _previousStep,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Report',
                          style: AppFont.style(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                        Text(
                          _currentStep == 1 
                              ? 'create_report_step_info'.tr() 
                              : 'create_report_step_info_2'.tr(),
                          style: AppFont.style(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Step Indicators
                Row(
                  children: List.generate(6, (index) {
                    bool isActive = index < _currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF1565C0) : const Color(0xFFF1F2F6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

          // ── Form Body ─────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
            ),
          ),

          // ── Bottom Buttons ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F2F6))),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: _previousStep,
                  child: Text(
                    'create_report_btn_cancel'.tr(),
                    style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'create_report_btn_next'.tr(),
                          style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service Provider Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F2F6)),
                ),
                child: const Icon(Icons.business_outlined, color: Color(0xFFA5ABB7)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'create_report_service_provider'.tr(),
                      style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                    ),
                    Text(
                      'Flowmax Pumps Corporation',
                      style: AppFont.style(fontSize: 15, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'create_report_date'.tr(),
                    style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                  ),
                  Text(
                    '11/05/2026',
                    style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Technician Name
        _buildLabel('create_report_tech_name'.tr()),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.person_outline, size: 20, color: Color(0xFFA5ABB7)),
            const SizedBox(width: 12),
            Text(
              'Mr. Rahul Mane',
              style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Customer Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_customer_name'.tr()),
            _buildAddNewButton('create_report_add_new'.tr()),
          ],
        ),
        _buildDropdownField('Select Customer'),

        const SizedBox(height: 32),

        // Site Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_site_name'.tr()),
            _buildAddNewButton('create_report_add_new'.tr()),
          ],
        ),
        _buildDropdownField('Select Site'),

        const SizedBox(height: 32),

        // Site Address
        _buildLabel('create_report_site_address'.tr()),
        const SizedBox(height: 12),
        Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'create_report_site_address_hint'.tr(),
                  style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                ),
              ),
              const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Complaint No
        Row(
          children: [
            _buildLabel('create_report_complaint_no'.tr()),
            const SizedBox(width: 40),
            Text(
              '-',
              style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Member Presents
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_member_presents'.tr()),
            _buildAddNewButton('create_report_add_plus'.tr()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'create_report_site_address_hint'.tr(),
              style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
            ),
            const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

        const SizedBox(height: 48),

        // Agenda / Purpose
        _buildLabel('create_report_agenda'.tr()),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'create_report_agenda_hint'.tr(),
                  style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                ),
              ),
              const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
            ],
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppFont.style(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFA5ABB7),
      ),
    );
  }

  Widget _buildAddNewButton(String text) {
    return Row(
      children: [
        const Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF1565C0)),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppFont.style(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF1565C0)),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String value) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
      ],
    );
  }
}
