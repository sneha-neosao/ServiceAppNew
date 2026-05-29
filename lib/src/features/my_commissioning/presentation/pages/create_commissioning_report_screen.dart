import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class CreateCommissioningReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final bool isServiceReport;
  const CreateCommissioningReportScreen({
    super.key,
    required this.onBack,
    this.isServiceReport = false,
  });

  @override
  State<CreateCommissioningReportScreen> createState() =>
      _CreateCommissioningReportScreenState();
}

class _CreateCommissioningReportScreenState
    extends State<CreateCommissioningReportScreen> {
  int _currentStep = 1;
  late List<TextEditingController> _technicians;
  int _workDescriptionRows = 5;

  @override
  void initState() {
    super.initState();
    final initialNames = widget.isServiceReport
        ? ['Pravin Patil']
        : ['Vinod Patil', 'Prashant Shinde'];
    _technicians = initialNames
        .map((name) => TextEditingController(text: name))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _technicians) {
      controller.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 6) {
      setState(() {
        _currentStep++;
      });
    } else {
      _showSuccessDialog();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFA5ABB7)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_success_title'.tr(),
                  style: AppFont.style(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'create_report_success_subtitle'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F2F6)),
                  ),
                  child: const Icon(
                    Icons.qr_code_2,
                    size: 180,
                    color: Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_scan_feedback'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onBack();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'create_report_btn_done'.tr(),
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStepInfo() {
    switch (_currentStep) {
      case 1:
        return 'create_report_step_info'.tr();
      case 2:
        return 'create_report_step_info_2'.tr();
      case 3:
        return 'create_report_step_info_3'.tr();
      case 4:
        return 'create_report_step_info_4'.tr();
      case 5:
        return 'create_report_step_info_5'.tr();
      case 6:
        return 'create_report_step_info_6'.tr();
      default:
        return 'STEP $_currentStep OF 6';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFA5ABB7),
                        ),
                        onPressed: _previousStep,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isServiceReport
                                ? 'Service Report'
                                : 'Commissioning Report',
                            style: AppFont.style(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                          Text(
                            _getStepInfo(),
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
                  // Progress Bar
                  Row(
                    children: List.generate(6, (index) {
                      bool isActive = index < _currentStep;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF1565C0)
                                : const Color(0xFFF1F2F6),
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

            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: _buildBodyContent(),
              ),
            ),

            // ── Footer ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F2F6))),
              ),
              child: Row(
                children: [
                  if (_currentStep > 1)
                    GestureDetector(
                      onTap: _previousStep,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xFFA5ABB7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'create_report_btn_back'.tr(),
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFA5ABB7),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: widget.onBack,
                      child: Text(
                        'create_report_btn_cancel'.tr(),
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _nextStep,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1565C0,
                            ).withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_currentStep == 6)
                            const Icon(
                              Icons.check_box_outlined,
                              size: 20,
                              color: Colors.white,
                            )
                          else
                            const SizedBox.shrink(),
                          if (_currentStep == 6)
                            const SizedBox(width: 12)
                          else
                            const SizedBox.shrink(),
                          Text(
                            _currentStep == 6
                                ? 'create_report_btn_submit'.tr().toUpperCase()
                                : 'create_report_btn_next'.tr().toUpperCase(),
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          if (_currentStep < 6)
                            const SizedBox(width: 12)
                          else
                            const SizedBox.shrink(),
                          if (_currentStep < 6)
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Colors.white,
                            )
                          else
                            const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      case 5:
        return _buildStep5();
      case 6:
        return _buildStep6();
      default:
        return const Center(child: Text("Coming Soon"));
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dealer Information Card ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF1F2F6)),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFFA5ABB7),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dealer Name',
                      style: AppFont.style(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Main Road, Suite 402, Business District,\nPune - 411045',
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8E9BAE),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Date',
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF8E9BAE),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '29/05/2026',
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── Service Provider Name ────────────────────────────────────────
        Text(
          'Service Provider Name',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF5C6672),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        Text(
          'Flowmax Pumps Corporation',
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),

        const SizedBox(height: 24),

        // ── Technician Name(s) ──────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Technician Name(s) :',
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5C6672),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _technicians.add(TextEditingController());
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF1F2F6)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 16, color: Color(0xFF1565C0)),
                    const SizedBox(width: 4),
                    Text(
                      '(Add+)',
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._technicians.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController controller = entry.value;
          bool isFirst = idx == 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: controller,
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                      decoration: InputDecoration(
                        hintText: '${idx + 1}) Technician Name...',
                        hintStyle: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFA5ABB7),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isFirst) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        var removed = _technicians.removeAt(idx);
                        removed.dispose();
                      });
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFFF5252),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        // ── Customer & Project Details ───────────────────────────────────
        _buildInfoRow('Customer Name', 'Global Infotech'),
        const SizedBox(height: 24),
        _buildInfoRow('Project / Site Name', 'Main Server Room'),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
        ),
        Text(
          ':',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable Step Builders (Placeholder logic for Steps 2-6)
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Member Context Label ─────────────────────────────────────────
        _buildLabel('Member Context'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 32),

        // ── Member Presents ─────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: Text(
                'Member Presents',
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Representative',
                          style: AppFont.style(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFA5ABB7), // Placeholder color
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.mic_none,
                        color: Color(0xFFA5ABB7),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Add+',
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF1F2F6),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // ── Select Warranty Period (Hidden for Service Report) ───────────
        if (!widget.isServiceReport) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  'Select Warranty Period',
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 YEAR',
                      style: AppFont.style(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF1F2F6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],

        // ── Purpose of Visit Section ─────────────────────────────────────
        _buildLabel('Purpose of Visit'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 32),

        // ── Purpose Text Area ────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Enter the main purpose of this visit...',
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                  ),
                  const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
                ],
              ),
              const SizedBox(height: 100),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.format_indent_increase,
                  size: 16,
                  color: Color(0xFF0D121F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Pump Details ────────────────────────────────────────────────
        _buildLabel('Pump Details'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        _buildInputFieldRow('Pump Make'),
        _buildInputFieldRow('Pump Model'),
        _buildInputFieldRow('Serial Number'),
        _buildInputFieldRow('Pump Head (MTR)'),
        _buildInputFieldRow('Flow (LPM)'),
        _buildInputFieldRow('Flow (M3/HR)'),
        _buildInputFieldRow('Flow (LPS)'),
        _buildInputFieldRow('Flow (USGPM)'),

        const SizedBox(height: 32),

        // ── Driver Details ──────────────────────────────────────────────
        _buildLabel('Driver Details'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        _buildInputFieldRow('Driver Make'),
        _buildInputFieldRow('Serial Number'),
        _buildInputFieldRow('Rating (KW)'),
        _buildInputFieldRow('Rating (HP)'),
        _buildInputFieldRow('RPM'),

        const SizedBox(height: 32),

        // ── Panel Details ───────────────────────────────────────────────
        _buildLabel('Panel Details'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        _buildInputFieldRow('Panel Make'),
        _buildInputFieldRow('Serial / Model'),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInputFieldRow(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D121F),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF1F2F6))),
              ),
              child: const SizedBox(height: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Work Description Label ──────────────────────────────────────
        _buildLabel('Work Description'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),

        // ── Work Description Fields ──────────────────────────────────────
        ...List.generate(
          _workDescriptionRows,
          (index) => _buildWorkDescriptionField(index + 1),
        ),

        const SizedBox(height: 8),

        // ── Add Row Button ──────────────────────────────────────────────
        GestureDetector(
          onTap: () {
            setState(() {
              _workDescriptionRows++;
            });
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF1F2F6), width: 1),
            ),
            child: Center(
              child: Text(
                '+ Add Row',
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildWorkDescriptionField(int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFA5ABB7),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFF1F2F6)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '...',
                          style: AppFont.style(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                      ),
                      const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.format_indent_increase,
                      size: 16,
                      color: Color(0xFF0D121F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Mechanical Section ──────────────────────────────────────────
        _buildSectionHeader(Icons.settings_outlined, 'MECHANICAL'),
        const SizedBox(height: 24),
        _buildChecklistRow('Bearing Noise', ['OK', 'NOT OK']),
        _buildChecklistRow('Vibration', ['NORMAL', 'HIGH']),
        _buildChecklistRow('Seal / Gland Leakage', ['OK', 'NOT OK']),
        _buildChecklistRow('Pump Not Running Dry', ['OK', 'NOT OK']),

        const SizedBox(height: 32),

        // ── Pipeline / Hydraulic Section ─────────────────────────────────
        _buildSectionHeader(Icons.water_drop_outlined, 'PIPELINE / HYDRAULIC'),
        const SizedBox(height: 24),
        _buildChecklistRow('NRV/Butterfly Valve', ['OK', 'NOT OK']),
        _buildChecklistRow('Strainer / Foot Valve', ['OK', 'NOT OK']),
        _buildChecklistRow('Line Leakage Check', ['OK', 'NOT OK']),
        _buildChecklistRow('Suction/Delivery Valve', ['OK', 'NOT OK']),

        const SizedBox(height: 32),

        // ── Electrical Section ───────────────────────────────────────────
        _buildSectionHeader(Icons.bolt_outlined, 'ELECTRICAL'),
        const SizedBox(height: 24),
        _buildChecklistRow('Electrical Faults', ['OK', 'NOT OK', 'NA']),
        _buildChecklistRow('Voltage Checked', ['OK', 'NOT OK', 'NA']),
        _buildChecklistRow('Phase Checked', ['OK', 'NOT OK', 'NA']),
        _buildChecklistRow('Current Checked', ['OK', 'NOT OK', 'NA']),
        _buildChecklistRow('Panel Wiring', ['OK', 'NOT OK', 'NA']),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF0D121F)),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
      ],
    );
  }

  Widget _buildChecklistRow(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFF1F2F6),
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      option,
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Remarks (Technician) ────────────────────────────────────────
        _buildLabel('REMARKS (TECHNICIAN)'),
        const SizedBox(height: 12),
        _buildRemarksBox('Technician side remarks...'),

        const SizedBox(height: 32),

        // ── Remarks (Customer) ──────────────────────────────────────────
        _buildLabel('REMARKS (CUSTOMER)'),
        const SizedBox(height: 12),
        _buildRemarksBox('Customer side remarks...'),

        const SizedBox(height: 32),

        // ── Photos Section ──────────────────────────────────────────────
        _buildLabel('Photos'),
        const SizedBox(height: 16),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFF1F2F6),
            ), // Should be dashed if possible
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFFA5ABB7),
                size: 32,
              ),
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
        _buildLabel('Technician Rep'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        _buildInfoRow('Name', 'Vinod Patil'),
        const SizedBox(height: 24),
        _buildInfoRow('Date', '12/05/2026'),
        const SizedBox(height: 24),
        _buildSignatureRow('Sign', 'Digitally Signed'),

        const SizedBox(height: 40),

        // ── Customer Rep ───────────────────────────────────────────────
        _buildLabel('Customer Rep'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),
        _buildInputFieldRow('Name'), // Reusing the input row helper
        const SizedBox(height: 24),
        _buildInfoRow('Date', '12/05/2026'),
        const SizedBox(height: 24),
        _buildSignatureRow('Sign', 'Signature Area'),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildRemarksBox(String placeholder) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  placeholder,
                  style: AppFont.style(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ),
              const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
            ],
          ),
          const SizedBox(height: 80),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.format_indent_increase,
              size: 16,
              color: Color(0xFF0D121F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureRow(String label, String placeholder) {
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
                  // fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderStep(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFont.style(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Icon(Icons.construction, size: 100, color: Color(0xFFF1F2F6)),
        ),
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
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1565C0),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA5ABB7),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
        ],
      ),
    );
  }
}
