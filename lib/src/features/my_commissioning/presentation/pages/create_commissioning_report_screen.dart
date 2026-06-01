import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_step1_autofill_bloc/commissioning_step1_autofill_bloc.dart';

import '../../../../remote/models/commissioning_report_step1_model/commissioning_report_step1_autofill_response.dart';

class CreateCommissioningReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final bool isServiceReport;
  final String commissioningWorkId;

  const CreateCommissioningReportScreen({
    super.key,
    required this.onBack,
    this.isServiceReport = false,
    required this.commissioningWorkId,
  });

  @override
  State<CreateCommissioningReportScreen> createState() =>
      _CreateCommissioningReportScreenState();
}

class _CreateCommissioningReportScreenState
    extends State<CreateCommissioningReportScreen> {
  int _currentStep = 1;
  late List<TextEditingController> _technicians;
  late List<TextEditingController> _representatives;
  String _selectedWarranty = '1 YEAR';
  bool _isTechnicalDetailsNA = false;
  int _workDescriptionRows = 5;

  // ── Step 5: Preventive Maintenance Checklist ──────────────────────────────
  // NA toggles per section
  bool _mechNA = false;
  bool _pipeNA = false;
  bool _elecNA = false;

  // Mechanical Checklist
  String? _bearingNoise;
  String? _vibration;
  String? _mechSeal;
  String? _pumpDry;

  // Pipeline / Hydraulic Checklist
  String? _nrvValve;
  String? _strainerValve;
  String? _suctionLine;
  String? _deliveryLine;
  String? _suctionDelivery;
  String? _pressureSwitch;

  // Electrical Checklist
  String? _elecFaults;
  String? _voltage;
  String? _phase;
  String? _current;
  String? _panelWiring;

  late CommissioningStep1AutoFillBloc _step1Bloc;
  late TechnicianBloc _technicianBloc;

  @override
  void initState() {
    super.initState();
    _step1Bloc = getIt<CommissioningStep1AutoFillBloc>()
      ..add(CommissioningStep1AutoFillGetEvent(widget.commissioningWorkId));
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());

    final initialNames = widget.isServiceReport
        ? ['Pravin Patil']
        : ['Vinod Patil', 'Prashant Shinde'];
    _technicians = initialNames
        .map((name) => TextEditingController(text: name))
        .toList();
    _representatives = [TextEditingController()];
  }

  @override
  void dispose() {
    _step1Bloc.close();
    _technicianBloc.close();
    for (var controller in _technicians) {
      controller.dispose();
    }
    for (var controller in _representatives) {
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
                                ? 'SERVICE REPORT'
                                : 'COMMISSIONING REPORT',
                            style: AppFont.style(
                              fontSize: 22,
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
        return BlocConsumer<CommissioningStep1AutoFillBloc, CommissioningStep1AutoFillState>(
          bloc: _step1Bloc,
          listener: (context, state) {
            if (state is CommissioningStep1AutoFillSuccessState) {
              setState(() {
                if (state.data.data.assignedTechnicians.isNotEmpty) {
                  _technicians.clear();
                  _technicians.addAll(state.data.data.assignedTechnicians
                      .map((t) => TextEditingController(text: t.name)));
                }
              });
            }
          },
          builder: (context, state) {
            if (state is CommissioningStep1AutoFillLoadingState || state is CommissioningStep1AutoFillInitialState) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                ),
              );
            }
            final data = state is CommissioningStep1AutoFillSuccessState ? state.data.data : null;
            return _buildStep1(data);
          },
        );
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

  Widget _buildStep1([CommissioningData? data]) {
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
                      data?.dealerName ?? 'Dealer Name',
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
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
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
                  child: BlocBuilder<TechnicianBloc, TechnicianState>(
                    bloc: _technicianBloc,
                    builder: (context, state) {
                      bool isLoading = state is TechnicianLoadingState;
                      List<String> validItems = [];
                      if (state is TechnicianSuccessState) {
                        validItems = state.data.data.map((e) => e.name).toList();
                      }
                      
                      final otherSelected = _technicians
                          .where((c) => c != controller && c.text.isNotEmpty)
                          .map((c) => c.text)
                          .toSet();
                      
                      validItems.removeWhere((item) => otherSelected.contains(item));

                      if (controller.text.isNotEmpty && !validItems.contains(controller.text)) {
                        validItems.add(controller.text);
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: isLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1565C0),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              )
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: controller.text.isNotEmpty ? controller.text : null,
                                  hint: Text(
                                    'Select Technician',
                                    style: AppFont.style(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFA5ABB7),
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
                                  style: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF0D121F),
                                  ),
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => controller.text = v);
                                    }
                                  },
                                  items: validItems
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                ),
                              ),
                      );
                    },
                  ),
                ),
                if (_technicians.length > 1) ...[
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
        _buildInfoRow('Customer Name', data?.customerName ?? 'Global Infotech'),
        const SizedBox(height: 24),
        _buildInfoRow('Project / Site Name', data?.siteName ?? 'Main Server Room'),
        const SizedBox(height: 24),
        _buildInfoRow('Application Of Equipment', data?.applicationOfEquipment ?? 'Pump Application'),

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Member Presents (Customer Side)',
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5C6672),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                ':',
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE5E7EB),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: _representatives.asMap().entries.map((entry) {
                  int idx = entry.key;
                  TextEditingController controller = entry.value;
                  bool isFirst = idx == 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF0D121F),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Representative',
                                  hintStyle: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.mic_off_outlined,
                              color: Color(0xFFA5ABB7),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            if (isFirst)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _representatives.add(
                                      TextEditingController(),
                                    );
                                  });
                                },
                                child: Text(
                                  'Add+',
                                  style: AppFont.style(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF1565C0),
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    var removed = _representatives.removeAt(
                                      idx,
                                    );
                                    removed.dispose();
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Color(0xFFFF5252),
                                  size: 24,
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
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ── Select Warranty Period (Hidden for Service Report) ───────────
        if (!widget.isServiceReport) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Select Warranty Period',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5C6672),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  ':',
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedWarranty,
                        isExpanded: true,
                        icon: const SizedBox.shrink(),
                        style: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0D121F),
                        ),
                        items:
                            ['1 YEAR', '2 YEAR', '3 YEAR', '4 YEAR', '5 YEAR']
                                .map(
                                  (val) => DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedWarranty = val;
                            });
                          }
                        },
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFF1565C0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],

        // ── Purpose of Visit Section ─────────────────────────────────────
        _buildLabel('Agenda / Purpose of Visit'),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),

        // ── Purpose Text Area ────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Stack(
            children: [
              TextField(
                maxLines: 5,
                style: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter the main purpose of this visit...',
                  hintStyle: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  Icons.mic_off_outlined,
                  color: Color(0xFFA5ABB7),
                  size: 20,
                ),
              ),
              const Positioned(
                bottom: 8,
                right: 8,
                child: Icon(
                  Icons.signal_cellular_4_bar,
                  size: 12,
                  color: Color(0xFFA5ABB7),
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
        // ── Technical Details ───────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Technical Details',
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(
                    () => _isTechnicalDetailsNA = !_isTechnicalDetailsNA,
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isTechnicalDetailsNA
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: _isTechnicalDetailsNA
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                    ),
                    child: _isTechnicalDetailsNA
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'NA',
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 32),

        // ── Input Fields ────────────────────────────────────────────────
        IgnorePointer(
          ignoring: _isTechnicalDetailsNA,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _isTechnicalDetailsNA ? 0.38 : 1.0,
            child: Column(
              children: [
                _buildTechField('Pump Make'),
                _buildTechField('Pump Model'),
                _buildTechField('Pump Serial Number'),
                _buildTechMultiField('Pump Flow', [
                  'LPM',
                  'M3/HR',
                  'LPS',
                  'USGPM',
                ]),
                _buildTechMultiField('Pump Head', ['MTR']),
                _buildTechField('Driver Make'),
                _buildTechField('Driver Serial Number'),
                _buildTechMultiField('Rating (KW/HP)', ['KW', 'HP']),
                _buildTechField('RPM'),
                _buildTechField('Control Panel Make'),
                _buildTechField('Panel Serial / Model'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTechField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF3A4152),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            style: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0D121F),
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F2F6)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1565C0), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechMultiField(String label, List<String> units) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF3A4152),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: units.map((unit) {
              return FractionallySizedBox(
                widthFactor: 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit,
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      style: AppFont.style(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0D121F),
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF1F2F6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1565C0),
                            width: 1.5,
                          ),
                        ),
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

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Work Description Label ──────────────────────────────────────
        Center(
          child: Text(
            'Work Description',
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFA5ABB7),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 24),

        // ── Work Description Fields ──────────────────────────────────────
        ...List.generate(3, (index) => _buildWorkDescriptionField(index + 1)),

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
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              '$number.',
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFA5ABB7),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Stack(
                children: [
                  TextField(
                    maxLines: 3,
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                    decoration: InputDecoration(
                      hintText: '...',
                      hintStyle: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: Icon(
                      Icons.mic_off_outlined,
                      color: Color(0xFFA5ABB7),
                      size: 20,
                    ),
                  ),
                  const Positioned(
                    bottom: 8,
                    right: 8,
                    child: Icon(
                      Icons.signal_cellular_4_bar,
                      size: 12,
                      color: Color(0xFFA5ABB7),
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
        // ── Title ─────────────────────────────────────────────────────────────
        Text(
          'Preventive Maintenance Checklist\n(Check & Tick if Found OK / NOT OK)',
          textAlign: TextAlign.center,
          style: AppFont.style(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 28),

        // ── Mechanical Checklist ───────────────────────────────────────────────
        _buildCheckSection(
          icon: Icons.settings_outlined,
          title: 'MECHANICAL CHECKLIST',
          isNA: _mechNA,
          onNATap: () => setState(() => _mechNA = !_mechNA),
          items: [
            _buildCheckItem(
              label: 'Bearing Noise / Abnormal Sound Checked:',
              selected: _bearingNoise,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _bearingNoise = v),
            ),
            _buildCheckItem(
              label: 'Vibration Checked:',
              selected: _vibration,
              options: const ['normal', 'high'],
              labels: const ['NORMAL', 'HIGH'],
              onSelect: (v) => setState(() => _vibration = v),
            ),
            _buildCheckItem(
              label: 'Mechanical Seal / Gland Leakage Checked:',
              selected: _mechSeal,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _mechSeal = v),
            ),
            _buildCheckItem(
              label: 'Pump Not Running Dry:',
              selected: _pumpDry,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _pumpDry = v),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── Pipeline / Hydraulic Checklist ────────────────────────────────────
        _buildCheckSection(
          icon: Icons.water_drop_outlined,
          title: 'PIPELINE / HYDRAULIC CHECKLIST',
          isNA: _pipeNA,
          onNATap: () => setState(() => _pipeNA = !_pipeNA),
          items: [
            _buildCheckItem(
              label: 'NRV / Butterfly Valve / Gate Valve Condition Checked:',
              selected: _nrvValve,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _nrvValve = v),
            ),
            _buildCheckItem(
              label: 'Strainer / Foot Valve Condition Checked:',
              selected: _strainerValve,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _strainerValve = v),
            ),
            _buildCheckItem(
              label: 'Suction Line (Air Leakage & Water Leakage Checked):',
              selected: _suctionLine,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _suctionLine = v),
            ),
            _buildCheckItem(
              label: 'Delivery Line (Air Leakage & Water Leakage Checked):',
              selected: _deliveryLine,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _deliveryLine = v),
            ),
            _buildCheckItem(
              label: 'Suction / Delivery Valve Condition Checked:',
              selected: _suctionDelivery,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _suctionDelivery = v),
            ),
            _buildCheckItem(
              label: 'Pressure Switch / Pressure Transmitter Checked:',
              selected: _pressureSwitch,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _pressureSwitch = v),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── Electrical Checklist ───────────────────────────────────────────────
        _buildCheckSection(
          icon: Icons.bolt_outlined,
          title: 'ELECTRICAL CHECKLIST',
          isNA: _elecNA,
          onNATap: () => setState(() => _elecNA = !_elecNA),
          items: [
            _buildCheckItem(
              label: 'Electrical Faults Checked:',
              selected: _elecFaults,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _elecFaults = v),
            ),
            _buildCheckItem(
              label: 'Voltage Checked:',
              selected: _voltage,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _voltage = v),
            ),
            _buildCheckItem(
              label: 'Phase Checked:',
              selected: _phase,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _phase = v),
            ),
            _buildCheckItem(
              label: 'Current Checked:',
              selected: _current,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _current = v),
            ),
            _buildCheckItem(
              label: 'Control Panel Wiring Checked:',
              selected: _panelWiring,
              options: const ['ok', 'notok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _panelWiring = v),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // ── Checklist section wrapper (header + NA + items with disable support) ───
  Widget _buildCheckSection({
    required IconData icon,
    required String title,
    required bool isNA,
    required VoidCallback onNATap,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF0D121F)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
            ),
            // NA checkbox
            GestureDetector(
              onTap: onNATap,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isNA
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: isNA ? const Color(0xFF1565C0) : Colors.white,
                    ),
                    child: isNA
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(NA)',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 12),

        // Items — disabled when NA is checked
        IgnorePointer(
          ignoring: isNA,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isNA ? 0.38 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
          ),
        ),
      ],
    );
  }

  // ── Single checklist item: label + radio-style option boxes ───────────────
  Widget _buildCheckItem({
    required String label,
    required String? selected,
    required List<String> options,
    required List<String> labels,
    required ValueChanged<String> onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF3A4152),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(options.length, (i) {
              final isSelected = selected == options[i];
              return Padding(
                padding: EdgeInsets.only(
                  right: i < options.length - 1 ? 20 : 0,
                ),
                child: GestureDetector(
                  onTap: () => onSelect(options[i]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Checkbox
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1565C0)
                                : const Color(0xFFCDD0D8),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        labels[i],
                        style: AppFont.style(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF7A8699),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Remarks (Technician Side) ─────────────────────────────────
        Text(
          'Remarks (Technician Side) :',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        _buildRemarksBox('Technician side remarks...'),

        const SizedBox(height: 28),

        // ── Remarks (Customer Side) ──────────────────────────────────
        Text(
          'Remarks (Customer Side) :',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7180),
          ),
        ),
        const SizedBox(height: 10),
        _buildRemarksBox('Customer side remarks...'),

        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),

        // ── Recorded By ────────────────────────────────────────────
        Text(
          'Recorded By :',
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),

        // Technician Rep
        Text(
          'TECHNICIAN REP',
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        _buildInfoRow('Name', 'Vinod Patil'),
        const SizedBox(height: 16),
        _buildSignatureBox('Sign', 'Digitally Signed'),

        const SizedBox(height: 36),

        // Customer Rep
        Text(
          'CUSTOMER REP',
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        // Editable name field
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              child: Text(
                'Name',
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF8E9BAE),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter name',
                  hintStyle: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA5ABB7),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD8DCE6)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF1565C0),
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSignatureBox('Sign', 'Signature Box'),

        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),

        // ── Upload / Capture Work Photos ──────────────────────────────
        Text(
          'Upload / Capture Work Photos :',
          style: AppFont.style(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 16),

        // Add Photo tile
        GestureDetector(
          onTap: () {}, // Add photo logic here
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFCDD0D8),
                width: 1.5,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 28,
                  color: Color(0xFFA5ABB7),
                ),
                const SizedBox(height: 6),
                Text(
                  'ADD+',
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildRemarksBox(String placeholder) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          TextField(
            maxLines: 4,
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const Positioned(
            top: 16,
            right: 16,
            child: Icon(
              Icons.mic_off_outlined,
              color: Color(0xFFA5ABB7),
              size: 20,
            ),
          ),
          const Positioned(
            bottom: 8,
            right: 8,
            child: Icon(
              Icons.signal_cellular_4_bar,
              size: 12,
              color: Color(0xFFA5ABB7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureBox(String label, String placeholder) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8E9BAE),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Center(
              child: Text(
                placeholder,
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFCDD0D8),
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
