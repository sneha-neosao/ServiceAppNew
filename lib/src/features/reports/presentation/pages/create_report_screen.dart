import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';

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
  bool _isCustomerAddNew =
      false; // true = show text field, false = show dropdown
  bool _isSiteAddNew = false; // true = show text field, false = show dropdown
  String _selectedCustomer = 'Select Customer';
  String _selectedSite = 'Select Site';

  final TextEditingController _newCustomerController = TextEditingController();
  final TextEditingController _newSiteController = TextEditingController();

  final List<String> _customersList = [];

  final List<String> _sitesList = [];

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;

  @override
  void initState() {
    super.initState();
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
  }

  // Dynamic list of member name fields – starts with one empty field
  final List<TextEditingController> _memberControllers = [
    TextEditingController(),
  ];
  // Mic toggle state for agenda field
  final TextEditingController _agendaController = TextEditingController();

  // ── Step 2: Technical Details ───────────────────────────────────────────────
  bool _isTechnicalNA = false;
  final TextEditingController _pumpMakeCtrl = TextEditingController();
  final TextEditingController _pumpModelCtrl = TextEditingController();
  final TextEditingController _pumpSerialCtrl = TextEditingController();
  final TextEditingController _pumpFlowLpmCtrl = TextEditingController();
  final TextEditingController _pumpFlowM3hrCtrl = TextEditingController();
  final TextEditingController _pumpFlowLpsCtrl = TextEditingController();
  final TextEditingController _pumpFlowUsgpmCtrl = TextEditingController();
  final TextEditingController _pumpHeadMtrCtrl = TextEditingController();
  final TextEditingController _driverMakeCtrl = TextEditingController();
  final TextEditingController _driverSerialCtrl = TextEditingController();
  final TextEditingController _ratingKwCtrl = TextEditingController();
  final TextEditingController _ratingHpCtrl = TextEditingController();
  final TextEditingController _rpmCtrl = TextEditingController();
  final TextEditingController _panelMakeCtrl = TextEditingController();
  final TextEditingController _panelSerialCtrl = TextEditingController();
  // Work Description – 3 rows initially
  final List<TextEditingController> _workDescControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void _addMemberField() {
    setState(() {
      _memberControllers.add(TextEditingController());
    });
  }

  void _removeMemberField(int index) {
    setState(() {
      _memberControllers[index].dispose();
      _memberControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _customerBloc.close();
    _sitesBloc.close();
    for (final c in _memberControllers) c.dispose();
    _agendaController.dispose();
    _newCustomerController.dispose();
    _newSiteController.dispose();
    // step 2
    _pumpMakeCtrl.dispose();
    _pumpModelCtrl.dispose();
    _pumpSerialCtrl.dispose();
    _pumpFlowLpmCtrl.dispose();
    _pumpFlowM3hrCtrl.dispose();
    _pumpFlowLpsCtrl.dispose();
    _pumpFlowUsgpmCtrl.dispose();
    _pumpHeadMtrCtrl.dispose();
    _driverMakeCtrl.dispose();
    _driverSerialCtrl.dispose();
    _ratingKwCtrl.dispose();
    _ratingHpCtrl.dispose();
    _rpmCtrl.dispose();
    _panelMakeCtrl.dispose();
    _panelSerialCtrl.dispose();
    for (final c in _workDescControllers) c.dispose();
    // step 4
    _remarksTechCtrl.dispose();
    _remarksCustomerCtrl.dispose();
    _customerRepNameCtrl.dispose();
    super.dispose();
  }

  // ── Step 3: Preventive Maintenance Checklist ──────────────────────────────
  // NA toggles per section
  bool _mechNA = false;
  bool _pipeNA = false;
  bool _elecNA = false;

  // Mechanical Checklist  (null = unset, 'ok' / 'notok' / 'normal' / 'high')
  String? _bearingNoise;
  String? _vibration; // 'normal' | 'high'
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

  // ── Step 4: Remarks + Photos + Recorded By ─────────────────────────────
  final TextEditingController _remarksTechCtrl = TextEditingController();
  final TextEditingController _remarksCustomerCtrl = TextEditingController();
  final TextEditingController _customerRepNameCtrl = TextEditingController();
  final List<XFile> _pickedPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickPhoto() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _pickedPhotos.add(file));
    }
  }

  void _removePhoto(int index) {
    setState(() => _pickedPhotos.removeAt(index));
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
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 40,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Card body ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Green success icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE8F5E9),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.20),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF4CAF50),
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Service Report Submitted',
                      textAlign: TextAlign.center,
                      style: AppFont.style(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'Scan for customer feedback',
                      textAlign: TextAlign.center,
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF1F2F6),
                    ),
                    const SizedBox(height: 24),

                    // QR code box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 160,
                            color: Color(0xFF0D121F),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Hint
                    Text(
                      'Scan To Provide Feedback',
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Complete button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
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
                          'Complete Service Report',
                          style: AppFont.style(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── ✕ close button ────────────────────────────────────────────
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF1F2F6),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            ],
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
      body: SafeArea(
        child: Column(
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
                          if (_currentStep == 4)
                            const Icon(
                              Icons.check_box_outlined,
                              size: 20,
                              color: Colors.white,
                            )
                          else
                            const SizedBox.shrink(),
                          if (_currentStep == 4)
                            const SizedBox(width: 12)
                          else
                            const SizedBox.shrink(),
                          Text(
                            _currentStep == 4
                                ? 'create_report_btn_submit'.tr()
                                : 'create_report_btn_next'.tr(),
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          if (_currentStep < 4)
                            const SizedBox(width: 12)
                          else
                            const SizedBox.shrink(),
                          if (_currentStep < 4)
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
      default:
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Text(
              "Coming Soon",
              style: AppFont.style(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
              ),
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
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFFA5ABB7),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'create_report_service_provider'.tr(),
                      style: AppFont.style(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                    Text(
                      'Flowmax Pumps Corporation',
                      style: AppFont.style(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'create_report_date'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                  Text(
                    '28/05/2026',
                    style: AppFont.style(
                      fontSize: 14,
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
              const Icon(
                Icons.person_outline,
                size: 20,
                color: Color(0xFFA5ABB7),
              ),
              const SizedBox(width: 12),
              Text(
                'Mr. Rahul Mane',
                style: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF8E9BAE),
                ),
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
        if (_isCustomerAddNew) ...[
          // ── Add New mode: text field
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
        ] else ...[
          // ── Select Existing mode: dropdown
          BlocBuilder<CustomerBloc, CustomerState>(
            bloc: _customerBloc,
            builder: (context, state) {
              bool isLoading = state is CustomerLoadingState;
              if (state is CustomerSuccessState) {
                final apiNames = state.data.data.map((e) => e.name).toList();
                for (var name in apiNames) {
                  if (!_customersList.contains(name)) _customersList.add(name);
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        setState(() {
                          _isCustomerDropdownOpen = !_isCustomerDropdownOpen;
                          _isSiteDropdownOpen = false;
                        });
                      }
                    },
                    child: _buildDropdownField(
                      isLoading ? 'Loading...' : _selectedCustomer,
                      _isCustomerDropdownOpen,
                      isLoading: isLoading,
                    ),
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
                        if (state is CustomerSuccessState) {
                          final cList = state.data.data.where(
                            (x) => x.name == val,
                          );
                          if (cList.isNotEmpty) {
                            _sitesBloc.add(SitesGetEvent(cList.first.id));
                          }
                        }
                      },
                    ),
                ],
              );
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
        if (_isSiteAddNew) ...[
          // ── Add New mode: text field
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
        ] else ...[
          // ── Select Existing mode: dropdown
          BlocBuilder<SitesBloc, SitesState>(
            bloc: _sitesBloc,
            builder: (context, state) {
              bool isLoading = state is SitesLoadingState;
              if (state is SitesSuccessState) {
                final apiNames = state.data.data.map((e) => e.name).toList();
                for (var name in apiNames) {
                  if (!_sitesList.contains(name)) _sitesList.add(name);
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        setState(() {
                          _isSiteDropdownOpen = !_isSiteDropdownOpen;
                          _isCustomerDropdownOpen = false;
                        });
                      }
                    },
                    child: _buildDropdownField(
                      isLoading ? 'Loading...' : _selectedSite,
                      _isSiteDropdownOpen,
                      isLoading: isLoading,
                    ),
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
              );
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
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
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
                  SpeechToTextMicButton(controller: ctrl),
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
                  style: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter the main purpose of this visit...',
                    hintStyle: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8E9BAE),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SpeechToTextMicButton(controller: _agendaController),
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
        // ── Technical Details header ────────────────────────────────────────
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
                  onTap: () => setState(() => _isTechnicalNA = !_isTechnicalNA),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isTechnicalNA
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: _isTechnicalNA
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                    ),
                    child: _isTechnicalNA
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'NA',
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── All fields wrapped: inactive + non-tappable when NA is checked ──────
        IgnorePointer(
          ignoring: _isTechnicalNA,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _isTechnicalNA ? 0.38 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Pump Make ──────────────────────────────────────────────
                _buildTechLabel('Pump Make'),
                _buildUnderlineField(_pumpMakeCtrl),
                const SizedBox(height: 20),

                // ── Pump Model ─────────────────────────────────────────────
                _buildTechLabel('Pump Model'),
                _buildUnderlineField(_pumpModelCtrl),
                const SizedBox(height: 20),

                // ── Pump Serial Number ─────────────────────────────────────
                _buildTechLabel('Pump Serial Number'),
                _buildUnderlineField(_pumpSerialCtrl),
                const SizedBox(height: 20),

                // ── Pump Flow (2×2 grid) ───────────────────────────────────
                _buildTechLabel('Pump Flow'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildUnitField(_pumpFlowLpmCtrl, 'LPM')),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUnitField(_pumpFlowM3hrCtrl, 'M3/HR'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildUnitField(_pumpFlowLpsCtrl, 'LPS')),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUnitField(_pumpFlowUsgpmCtrl, 'USGPM'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Pump Head ──────────────────────────────────────────────
                _buildTechLabel('Pump Head'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildUnitField(_pumpHeadMtrCtrl, 'MTR'),
                    ),
                    const Spacer(flex: 5),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 24),

                // ── Driver Make ────────────────────────────────────────────
                _buildTechLabel('Driver Make'),
                _buildUnderlineField(_driverMakeCtrl),
                const SizedBox(height: 20),

                // ── Driver Serial Number ───────────────────────────────────
                _buildTechLabel('Driver Serial Number'),
                _buildUnderlineField(_driverSerialCtrl),
                const SizedBox(height: 20),

                // ── Rating (KW / HP) ───────────────────────────────────────
                _buildTechLabel('Rating (KW/HP)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildUnitField(_ratingKwCtrl, 'KW')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildUnitField(_ratingHpCtrl, 'HP')),
                  ],
                ),
                const SizedBox(height: 20),

                // ── RPM ────────────────────────────────────────────────────
                _buildTechLabel('RPM'),
                _buildUnderlineField(_rpmCtrl),
                const SizedBox(height: 32),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 24),

                // ── Control Panel Make ─────────────────────────────────────
                _buildTechLabel('Control Panel Make'),
                _buildUnderlineField(_panelMakeCtrl),
                const SizedBox(height: 20),

                // ── Panel Serial / Model ───────────────────────────────────
                _buildTechLabel('Panel Serial / Model'),
                _buildUnderlineField(_panelSerialCtrl),
                const SizedBox(height: 40),

                // ── Work Description ───────────────────────────────────────
                Center(
                  child: Text(
                    'Work Description',
                    style: AppFont.style(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                ...List.generate(_workDescControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, right: 8),
                          child: Text(
                            '${index + 1}.',
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFA5ABB7),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Focus(
                            child: Builder(
                              builder: (ctx) {
                                final hasFocus = Focus.of(ctx).hasFocus;
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    10,
                                    10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: hasFocus
                                          ? const Color(0xFF1565C0)
                                          : const Color(0xFFF1F2F6),
                                      width: hasFocus ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              _workDescControllers[index],
                                          minLines: 3,
                                          maxLines: null,
                                          style: AppFont.style(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF0D121F),
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '...',
                                            hintStyle: AppFont.style(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFFA5ABB7),
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      SpeechToTextMicButton(
                                        controller: _workDescControllers[index],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Underline text field (label above, full-width input with bottom border) ──
  Widget _buildTechLabel(String text) {
    return Text(
      text,
      style: AppFont.style(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF3A4152),
      ),
    );
  }

  Widget _buildUnderlineField(TextEditingController ctrl, {String hint = ''}) {
    return TextField(
      controller: ctrl,
      style: AppFont.style(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF0D121F),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFont.style(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFA5ABB7),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD8DCE6)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1565C0), width: 1.5),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  // ── Unit field: input + unit label above the underline ───────────────────────
  Widget _buildUnitField(TextEditingController ctrl, String unit) {
    return Column(
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
        _buildUnderlineField(ctrl),
      ],
    );
  }

  Widget _buildStep3() {
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
          title: 'Mechanical Checklist',
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
          title: 'Pipeline / Hydraulic Checklist',
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
          title: 'Electrical Checklist',
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
                  fontSize: 15,
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
                    'NA',
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
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : const Color(0xFF6B7280),
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

  Widget _buildStep4() {
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
        _buildRemarksBox(
          controller: _remarksTechCtrl,
          hint: 'Technician side remarks...',
        ),

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
        _buildRemarksBox(
          controller: _remarksCustomerCtrl,
          hint: 'Customer side remarks...',
        ),

        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),

        // ── Photos ────────────────────────────────────────────────
        Row(
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 20,
              color: Color(0xFF0D121F),
            ),
            const SizedBox(width: 8),
            Text(
              'Photos',
              style: AppFont.style(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),

        // Photo grid: thumbnails + Add Photo tile
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Existing photo thumbnails
            ..._pickedPhotos.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(file.path),
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            // Add Photo tile
            GestureDetector(
              onTap: _pickPhoto,
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
                      'Add Photo',
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
          ],
        ),

        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),

        // ── Recorded By ────────────────────────────────────────────
        Text(
          'Recorded By:',
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
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
        _buildSignatureRow('Name', 'Mr. Rahul Mane', isBold: true),
        const SizedBox(height: 16),
        _buildSignatureBox('Sign', 'create_report_digitally_signed'.tr()),

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
                controller: _customerRepNameCtrl,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSignatureBox('Sign', 'create_report_signature_area'.tr()),

        const SizedBox(height: 60),
      ],
    );
  }

  // ── Remarks text area with toggle mic ────────────────────────────────
  Widget _buildRemarksBox({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
              controller: controller,
              minLines: 4,
              maxLines: null,
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA5ABB7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SpeechToTextMicButton(controller: controller),
        ],
      ),
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
              const Icon(
                Icons.camera_alt_outlined,
                size: 32,
                color: Color(0xFFA5ABB7),
              ),
              const SizedBox(height: 8),
              Text(
                'create_report_add_photo'.tr(),
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
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
          style: AppFont.style(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 40),

        // Technician Rep
        _buildLabel('create_report_tech_rep'.tr()),
        const SizedBox(height: 24),
        _buildSignatureRow(
          'create_report_name'.tr(),
          'Mr. Rahul Mane',
          isBold: true,
        ),
        const SizedBox(height: 24),
        _buildSignatureBox(
          'create_report_sign'.tr(),
          'create_report_digitally_signed'.tr(),
        ),

        const SizedBox(height: 60),

        // Customer Rep
        _buildLabel('create_report_customer_rep'.tr()),
        const SizedBox(height: 24),
        _buildSignatureRow(
          'create_report_name'.tr(),
          'Enter name',
          isPlaceholder: true,
        ),
        const SizedBox(height: 24),
        _buildSignatureBox(
          'create_report_sign'.tr(),
          'create_report_signature_area'.tr(),
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildSignatureRow(
    String label,
    String value, {
    bool isBold = false,
    bool isPlaceholder = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8E9BAE),
            ),
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
                  color: isPlaceholder
                      ? const Color(0xFFA5ABB7)
                      : const Color(0xFF0D121F),
                ),
              ),
              if (isPlaceholder) ...[
                const SizedBox(height: 4),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
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
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8E9BAE),
            ),
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
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFCFD8DC),
                ),
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
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA5ABB7),
            ),
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
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.mic_none,
                    size: 18,
                    color: Color(0xFFA5ABB7),
                  ),
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
          style: AppFont.style(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
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
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
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
        const Icon(
          Icons.add_circle_outline,
          size: 16,
          color: Color(0xFF1565C0),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectExistingButton() {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 16,
          color: Color(0xFF1565C0),
        ),
        const SizedBox(width: 4),
        Text(
          'Select Existing',
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String value,
    bool isOpen, {
    bool isLoading = false,
  }) {
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
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
          ),
          isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Color(0xFF1565C0),
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
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
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          // List items
          ...items.map(
            (item) => GestureDetector(
              onTap: () => onSelect(item),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  item,
                  style: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF0D121F),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
