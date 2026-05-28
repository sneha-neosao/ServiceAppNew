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

  bool _isCustomerDropdownOpen = false;
  bool _isSiteDropdownOpen = false;
  bool _isCustomerAddNew = false;   // true = show text field, false = show dropdown
  bool _isSiteAddNew = false;        // true = show text field, false = show dropdown
  String _selectedCustomer = 'Select Customer';
  String _selectedSite = 'Select Site';

  final TextEditingController _newCustomerController = TextEditingController();
  final TextEditingController _newSiteController = TextEditingController();

  final List<String> _customersList = [
    'Gera Developers Pvt. Ltd.',
    'Global Infotech',
    'Reliance Mart',
  ];

  final List<String> _sitesList = [
    'Imperium Gateway',
    'Main Server Room',
    'Chiller Plant',
  ];

  // Dynamic list of member name fields – starts with one empty field
  final List<TextEditingController> _memberControllers = [TextEditingController()];
  final TextEditingController _agendaController = TextEditingController();

  void _addMemberField() {
    setState(() => _memberControllers.add(TextEditingController()));
  }

  void _removeMemberField(int index) {
    setState(() {
      _memberControllers[index].dispose();
      _memberControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (final c in _memberControllers) c.dispose();
    _agendaController.dispose();
    _newCustomerController.dispose();
    _newSiteController.dispose();
    super.dispose();
  }

  void _simulateSpeech(TextEditingController controller) {
    setState(() {
      controller.text = controller.text.isEmpty 
          ? "Spoken text added via mic" 
          : "${controller.text} Spoken text added via mic";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulated Speech-to-Text input')),
    );
  }

  void _nextStep() {
    if (_currentStep < 4) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 40),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_success_title'.tr(),
                  style: AppFont.style(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                ),
                const SizedBox(height: 8),
                Text(
                  'create_report_success_subtitle'.tr(),
                  style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F2F6)),
                  ),
                  child: const Icon(Icons.qr_code_2, size: 180, color: Color(0xFF0D121F)),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_scan_feedback'.tr(),
                  style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close Dialog
                      widget.onBack(); // Go Home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      'create_report_btn_done'.tr(),
                      style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
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
      default:
        return 'STEP $_currentStep OF 4';
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
                          'SERVICE / WORK REPORT',
                          style: AppFont.style(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                        // Text(
                        //   _getStepInfo(),
                        //   style: AppFont.style(
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w800,
                        //     color: const Color(0xFFA5ABB7),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Step Indicators
                Row(
                  children: List.generate(4, (index) {
                    bool isActive = index < _currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
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
              child: _buildBodyContent(),
            ),
          ),

          // ── Bottom Buttons ────────────────────────────────────────────────
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
                        const Icon(Icons.arrow_back, size: 18, color: Color(0xFFA5ABB7)),
                        const SizedBox(width: 8),
                        Text(
                          'create_report_btn_back'.tr(),
                          style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                        ),
                      ],
                    ),
                  )
                else
                  TextButton(
                    onPressed: widget.onBack,
                    child: Text(
                      'create_report_btn_cancel'.tr(),
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
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
                          color: const Color(0xFF1565C0).withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_currentStep == 4)
                          const Icon(Icons.check_box_outlined, size: 20, color: Colors.white)
                        else
                          const SizedBox.shrink(),
                        if (_currentStep == 4) const SizedBox(width: 12) else const SizedBox.shrink(),
                        Text(
                          _currentStep == 4 ? 'create_report_btn_submit'.tr() : 'create_report_btn_next'.tr(),
                          style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        if (_currentStep < 4) const SizedBox(width: 12) else const SizedBox.shrink(),
                        if (_currentStep < 4)
                          const Icon(Icons.arrow_forward, size: 18, color: Colors.white)
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
    );
  }

  Widget _buildBodyContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      default:
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Text(
              "Coming Soon",
              style: AppFont.style(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
            ),
          ),
        );
    }
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
                    '28/05/2026',
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_outline, size: 20, color: Color(0xFFA5ABB7)),
              const SizedBox(width: 12),
              Text(
                'Mr. Rahul Mane',
                style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF8E9BAE)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Customer Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_customer_name'.tr()),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCustomerAddNew = !_isCustomerAddNew;
                  // Reset dropdown when switching modes
                  _isCustomerDropdownOpen = false;
                  _newCustomerController.clear();
                });
              },
              child: _isCustomerAddNew
                  ? _buildSelectExistingButton()
                  : _buildAddNewButton('create_report_add_new'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isCustomerAddNew) ...[  // ── Add New mode: text field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1565C0)),
            ),
            child: TextField(
              controller: _newCustomerController,
              autofocus: true,
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: 'Enter new customer name',
                hintStyle: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA5ABB7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ] else ...[                  // ── Select Existing mode: dropdown
          GestureDetector(
            onTap: () {
              setState(() {
                _isCustomerDropdownOpen = !_isCustomerDropdownOpen;
                _isSiteDropdownOpen = false;
              });
            },
            child: _buildDropdownField(_selectedCustomer, _isCustomerDropdownOpen),
          ),
          if (_isCustomerDropdownOpen)
            _buildDropdownList(
              title: 'Select Customer',
              items: _customersList,
              onSelect: (val) {
                setState(() {
                  _selectedCustomer = val;
                  _isCustomerDropdownOpen = false;
                });
              },
            ),
        ],

        const SizedBox(height: 32),

        // Site Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_site_name'.tr()),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSiteAddNew = !_isSiteAddNew;
                  // Reset dropdown when switching modes
                  _isSiteDropdownOpen = false;
                  _newSiteController.clear();
                });
              },
              child: _isSiteAddNew
                  ? _buildSelectExistingButton()
                  : _buildAddNewButton('create_report_add_new'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isSiteAddNew) ...[  // ── Add New mode: text field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1565C0)),
            ),
            child: TextField(
              controller: _newSiteController,
              autofocus: true,
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: 'Enter new site name',
                hintStyle: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA5ABB7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ] else ...[                  // ── Select Existing mode: dropdown
          GestureDetector(
            onTap: () {
              setState(() {
                _isSiteDropdownOpen = !_isSiteDropdownOpen;
                _isCustomerDropdownOpen = false;
              });
            },
            child: _buildDropdownField(_selectedSite, _isSiteDropdownOpen),
          ),
          if (_isSiteDropdownOpen)
            _buildDropdownList(
              title: 'Select Site',
              items: _sitesList,
              onSelect: (val) {
                setState(() {
                  _selectedSite = val;
                  _isSiteDropdownOpen = false;
                });
              },
            ),
        ],

        const SizedBox(height: 32),

        // Complaint No
        Row(
          children: [
            _buildLabel('create_report_complaint_no'.tr()),
            const SizedBox(width: 40),
            Text(
              ':    -',
              style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 32),

        // Member Presents
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_member_presents'.tr()),
            GestureDetector(
              onTap: _addMemberField,
              child: _buildAddNewButton('create_report_add_plus'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Render one row per controller
        ...List.generate(_memberControllers.length, (index) {
          final ctrl = _memberControllers[index];
          final isFirst = index == 0;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                      decoration: InputDecoration(
                        hintText: 'name',
                        hintStyle: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF8E9BAE),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _simulateSpeech(ctrl),
                    child: const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
                  ),
                  if (!isFirst) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeMemberField(index),
                      child: const Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xFFE53935),
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
              if (index < _memberControllers.length - 1)
                const SizedBox(height: 8),
            ],
          );
        }),

        const SizedBox(height: 48),

        // Agenda / Purpose
        _buildLabel('create_report_agenda'.tr()),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _agendaController,
                  maxLines: null,
                  style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0D121F)),
                  decoration: InputDecoration(
                    hintText: 'Enter the main purpose of this visit...',
                    hintStyle: AppFont.style(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF8E9BAE)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _simulateSpeech(_agendaController),
                  child: const Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
                ),
              ),
            ],
          ),
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

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pump Details
        _buildSectionTitle('create_report_pump_details'.tr()),
        _buildInlineField('create_report_pump_make'.tr()),
        _buildInlineField('create_report_pump_model'.tr()),
        _buildInlineField('create_report_pump_serial'.tr()),
        _buildInlineField('create_report_pump_flow'.tr()),
        _buildInlineField('create_report_pump_head'.tr()),

        const SizedBox(height: 48),

        // Driver Details
        _buildSectionTitle('create_report_driver_details'.tr()),
        _buildInlineField('create_report_driver_make'.tr()),
        _buildInlineField('create_report_driver_serial'.tr()),
        _buildInlineField('create_report_driver_rating'.tr()),
        _buildInlineField('create_report_driver_rpm'.tr()),

        const SizedBox(height: 48),

        // Panel Details
        _buildSectionTitle('create_report_panel_details'.tr()),
        _buildInlineField('create_report_panel_make'.tr()),
        _buildInlineField('create_report_panel_serial_model'.tr()),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('create_report_work_description'.tr()),
        const SizedBox(height: 8),
        ...List.generate(8, (index) => _buildWorkRow(index + 1)),
        const SizedBox(height: 20),
        // Add More Rows Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6), width: 1, style: BorderStyle.solid),
          ),
          child: Center(
            child: Text(
              'create_report_add_more_rows'.tr(),
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Remarks Tech
        _buildLabel('create_report_remarks_tech'.tr()),
        const SizedBox(height: 16),
        Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SizedBox()),
              Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Remarks Customer
        _buildLabel('create_report_remarks_customer'.tr()),
        const SizedBox(height: 16),
        Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SizedBox()),
              Icon(Icons.mic_none, color: Color(0xFFA5ABB7)),
            ],
          ),
        ),

        const SizedBox(height: 48),

        // Photos Section
        _buildLabel('create_report_upload_photos'.tr()),
        const SizedBox(height: 20),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, size: 32, color: Color(0xFFA5ABB7)),
              const SizedBox(height: 8),
              Text(
                'create_report_add_photo'.tr(),
                style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'create_report_recorded_by'.tr(),
          style: AppFont.style(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 40),

        // Technician Rep
        _buildLabel('create_report_tech_rep'.tr()),
        const SizedBox(height: 24),
        _buildSignatureRow('create_report_name'.tr(), 'Mr. Rahul Mane', isBold: true),
        const SizedBox(height: 24),
        _buildSignatureBox('create_report_sign'.tr(), 'create_report_digitally_signed'.tr()),

        const SizedBox(height: 60),

        // Customer Rep
        _buildLabel('create_report_customer_rep'.tr()),
        const SizedBox(height: 24),
        _buildSignatureRow('create_report_name'.tr(), 'Enter name', isPlaceholder: true),
        const SizedBox(height: 24),
        _buildSignatureBox('create_report_sign'.tr(), 'create_report_signature_area'.tr()),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildSignatureRow(String label, String value, {bool isBold = false, bool isPlaceholder = false}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF8E9BAE)),
          ),
        ),
        const SizedBox(width: 16),
        const Text(':', style: TextStyle(color: Color(0xFFF1F2F6))),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppFont.style(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.w800,
                  color: isPlaceholder ? const Color(0xFFA5ABB7) : const Color(0xFF0D121F),
                ),
              ),
              if (isPlaceholder) ...[
                const SizedBox(height: 4),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureBox(String label, String hint) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF8E9BAE)),
          ),
        ),
        const SizedBox(width: 16),
        const Text(':', style: TextStyle(color: Color(0xFFF1F2F6))),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F2F6)),
            ),
            child: Center(
              child: Text(
                hint.tr(),
                style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFCFD8DC)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkRow(int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 64,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF1F2F6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '...',
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                    ),
                  ),
                  const Icon(Icons.mic_none, size: 18, color: Color(0xFFA5ABB7)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInlineField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
            ),
          ),
          const Expanded(
            flex: 6,
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
          ),
        ],
      ),
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

  Widget _buildSelectExistingButton() {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF1565C0)),
        const SizedBox(width: 4),
        Text(
          'Select Existing',
          style: AppFont.style(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF1565C0)),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String value, bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOpen ? const Color(0xFF1565C0) : const Color(0xFFF1F2F6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
        ],
      ),
    );
  }

  Widget _buildDropdownList({
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelect,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF757575), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header item
          Container(
            color: const Color(0xFF757575),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              title,
              style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
            ),
          ),
          // List items
          ...items.map((item) => GestureDetector(
                onTap: () => onSelect(item),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    item,
                    style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF0D121F)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
