import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_create_bloc/commissioning_work_create_bloc.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';

class AddCommissioningScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String? initialCustomer;
  final String? initialSite;
  final String? initialEquipment;
  final String? initialTechnicians;

  const AddCommissioningScreen({
    super.key,
    required this.onBack,
    this.initialCustomer,
    this.initialSite,
    this.initialEquipment,
    this.initialTechnicians,
  });

  @override
  State<AddCommissioningScreen> createState() => _AddCommissioningScreenState();
}

class _AddCommissioningScreenState extends State<AddCommissioningScreen> {
  // ── Customer ──────────────────────────────────────────────────────────────
  List<String> _customers = [];
  String? _selectedCustomer;

  // ── Site / Location ───────────────────────────────────────────────────────
  List<String> _sites = [];
  String? _selectedSite;

  // ── Equipment ─────────────────────────────────────────────────────────────
  late TextEditingController _equipmentController;

  // ── Technicians ───────────────────────────────────────────────────────────
  List<String> _technicians = [];
  String? _selectedTechnician;

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late TechnicianBloc _technicianBloc;
  late CommissioningWorkCreateBloc _createBloc;

  @override
  void initState() {
    super.initState();

    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
    _createBloc = getIt<CommissioningWorkCreateBloc>();
    _equipmentController = TextEditingController(text: widget.initialEquipment);

    // ── Customer ─────────────────────────────────────────────────────────────
    if (widget.initialCustomer != null) {
      if (!_customers.contains(widget.initialCustomer)) {
        _customers.insert(0, widget.initialCustomer!);
      }
      _selectedCustomer = widget.initialCustomer;
    }

    // ── Site ─────────────────────────────────────────────────────────────────
    if (widget.initialSite != null) {
      if (!_sites.contains(widget.initialSite)) {
        _sites.insert(0, widget.initialSite!);
      }
      _selectedSite = widget.initialSite;
    }

    // ── Technician — only set if the value exists as a single list item ───────
    // initialTechnicians may be a comma-joined string like "A, B"; guard it.
    if (widget.initialTechnicians != null) {
      if (!_technicians.contains(widget.initialTechnicians)) {
        _technicians.insert(0, widget.initialTechnicians!);
      }
      _selectedTechnician = widget.initialTechnicians;
    }
  }

  @override
  void dispose() {
    _customerBloc.close();
    _sitesBloc.close();
    _technicianBloc.close();
    _createBloc.close();
    _equipmentController.dispose();
    super.dispose();
  }

  // ── Bottom sheet: Add new entry ────────────────────────────────────────────
  Future<void> _showAddBottomSheet({
    required String fieldLabel,
    required List<String> list,
    required void Function(String) onSaved,
  }) async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New $fieldLabel',
                    style: AppFont.style(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF1F2F6)),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFFA5ABB7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'NAME',
                style: AppFont.style(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                autofocus: true,
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'Type here...',
                  hintStyle: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFA5ABB7),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FB),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1565C0),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      Navigator.pop(ctx);
                      onSaved(text);
                    }
                  },
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: Text(
                    'SAVE ENTRY',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF1565C0,
                    ), // matching the blue
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    // Delay disposal to allow bottom sheet closing animation to finish and prevent TextField from using disposed controller
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.dispose();
    });
  }

  // ── Assign button handler ──────────────────────────────────────────────────
  void _onAssign() {
    String customerId = "";
    final customerState = _customerBloc.state;
    if (customerState is CustomerSuccessState) {
      for (var c in customerState.data.data) {
        if (c.name == _selectedCustomer) {
          customerId = c.id;
          break;
        }
      }
    }

    String siteId = "";
    final siteState = _sitesBloc.state;
    if (siteState is SitesSuccessState) {
      for (var s in siteState.data.data) {
        if (s.name == _selectedSite) {
          siteId = s.id;
          break;
        }
      }
    }

    final appOfEquipment = _equipmentController.text.trim();

    String technicianId = "";
    final techState = _technicianBloc.state;
    if (techState is TechnicianSuccessState) {
      for (var t in techState.data.data) {
        if (t.name == _selectedTechnician) {
          technicianId = t.id;
          break;
        }
      }
    }

    _createBloc.add(
      CommissioningWorkCreateSubmitEvent(
        customerId: customerId,
        siteId: siteId,
        applicationOfEquipment: appOfEquipment,
        technicians: technicianId.isNotEmpty ? [technicianId] : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      CommissioningWorkCreateBloc,
      CommissioningWorkCreateState
    >(
      bloc: _createBloc,
      listener: (context, state) {
        if (state is CommissioningWorkCreateSuccessState) {
          appSnackBar(context, const Color(0xFF4CAF50), state.data.message);
          widget.onBack();
        } else if (state is CommissioningWorkCreateFailureState) {
          appSnackBar(context, const Color(0xFFF44336), state.message);
        }
      },
      child: PopScope(
        // Intercept Android system back button
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) widget.onBack();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF5C616E),
                          ),
                          onPressed: widget.onBack,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B68B9),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.initialCustomer != null
                              ? 'Edit Commissioning Work'
                              : 'Assign For New Commissioning Work',
                          style: AppFont.style(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF002C5E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),

                // ── Form body ────────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // ── STEP 1: SELECT CUSTOMER ──────────────────────────
                        _buildSectionHeader(
                          label: 'STEP 1: SELECT CUSTOMER',
                          onAddTap: () => _showAddBottomSheet(
                            fieldLabel: 'Customer',
                            list: _customers,
                            onSaved: (val) => setState(() {
                              _customers.insert(0, val);
                              _selectedCustomer = val;
                              _selectedSite = null;
                              _sites.clear();
                            }),
                          ),
                        ),
                        BlocBuilder<CustomerBloc, CustomerState>(
                          bloc: _customerBloc,
                          builder: (context, state) {
                            bool isLoading = state is CustomerLoadingState;
                            if (state is CustomerSuccessState) {
                              final apiNames = state.data.data
                                  .map((e) => e.name)
                                  .toList();
                              for (var name in apiNames) {
                                if (!_customers.contains(name)) {
                                  _customers.add(name);
                                }
                              }
                            }
                            return _buildDropdown(
                              hint: 'Select Customer',
                              value: _selectedCustomer,
                              items: _customers,
                              isLoading: isLoading,
                              onChanged: (v) {
                                setState(() {
                                  _selectedCustomer = v;
                                  _selectedSite = null;
                                  _sites.clear();
                                });
                                if (v != null &&
                                    state is CustomerSuccessState) {
                                  final cList = state.data.data.where(
                                    (x) => x.name == v,
                                  );
                                  if (cList.isNotEmpty) {
                                    _sitesBloc.add(
                                      SitesGetEvent(cList.first.id),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // ── STEP 2: SELECT SITE ──────────────────────────────
                        _buildSectionHeader(
                          label: 'STEP 2: SELECT SITE',
                          onAddTap: _selectedCustomer != null
                              ? () => _showAddBottomSheet(
                                  fieldLabel: 'Site',
                                  list: _sites,
                                  onSaved: (val) => setState(() {
                                    _sites.insert(0, val);
                                    _selectedSite = val;
                                  }),
                                )
                              : null,
                        ),
                        BlocBuilder<SitesBloc, SitesState>(
                          bloc: _sitesBloc,
                          builder: (context, state) {
                            bool isLoading = state is SitesLoadingState;
                            if (state is SitesSuccessState) {
                              final apiNames = state.data.data
                                  .map((e) => e.name)
                                  .toList();
                              for (var name in apiNames) {
                                if (!_sites.contains(name)) _sites.add(name);
                              }
                            }
                            return _buildDropdown(
                              hint: 'Choose Site...',
                              value: _selectedSite,
                              items: _sites,
                              isLoading: isLoading,
                              onChanged: _selectedCustomer != null
                                  ? (v) => setState(() => _selectedSite = v)
                                  : null,
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // ── STEP 3: APPLICATION OF EQUIPMENT ─────────────────
                        _buildSectionHeader(
                          label: 'STEP 3: APPLICATION OF EQUIPMENT',
                          showAdd: false,
                        ),
                        _buildTextField(
                          hint: 'Enter Application of Equipment',
                          controller: _equipmentController,
                        ),

                        const SizedBox(height: 32),

                        // ── STEP 4: ASSIGN TECHNICIANS ───────────────────────
                        _buildSectionHeader(
                          label: 'STEP 4: ASSIGN TECHNICIANS',
                          showAdd: false,
                        ),
                        BlocBuilder<TechnicianBloc, TechnicianState>(
                          bloc: _technicianBloc,
                          builder: (context, state) {
                            bool isLoading = state is TechnicianLoadingState;
                            if (state is TechnicianSuccessState) {
                              final apiNames = state.data.data
                                  .map((e) => e.name)
                                  .toList();
                              for (var name in apiNames) {
                                if (!_technicians.contains(name))
                                  _technicians.add(name);
                              }
                            }
                            return _buildDropdown(
                              hint: 'Choose Technicians...',
                              value: _selectedTechnician,
                              items: _technicians,
                              isLoading: isLoading,
                              onChanged: (v) =>
                                  setState(() => _selectedTechnician = v),
                            );
                          },
                        ),

                        const SizedBox(height: 48),

                        // ── Assign Button ──────────────────────────────────
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF1565C0,
                                ).withOpacity(0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child:
                              BlocBuilder<
                                CommissioningWorkCreateBloc,
                                CommissioningWorkCreateState
                              >(
                                bloc: _createBloc,
                                builder: (context, state) {
                                  final isLoading =
                                      state
                                          is CommissioningWorkCreateLoadingState;
                                  return ElevatedButton(
                                    onPressed: isLoading ? null : _onAssign,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1565C0),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'ASSIGN',
                                                style: AppFont.style(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Section header with optional "+" button ────────────────────────────────
  Widget _buildSectionHeader({
    required String label,
    bool showAdd = true,
    VoidCallback? onAddTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: AppFont.style(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFA2AEC0),
                letterSpacing: 0.8,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: AppFont.style(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0B68B9),
                  ),
                ),
              ],
            ),
          ),
          if (showAdd && onAddTap != null)
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF1565C0).withOpacity(0.15),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Styled dropdown ────────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    bool isLoading = false,
  }) {
    // Make sure current value is in items to avoid DropdownButton error
    List<String> validItems = List.from(items);
    if (value != null && !validItems.contains(value)) {
      validItems.add(value);
    }

    final bool isEnabled = onChanged != null;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFF8F9FB) : const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFF1565C0),
                  strokeWidth: 2.5,
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                hint: Text(
                  hint,
                  style: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isEnabled
                        ? const Color(0xFFA5ABB7)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: isEnabled
                      ? const Color(0xFFA5ABB7)
                      : const Color(0xFFCBD5E1),
                ),
                dropdownColor: Colors.white,
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isEnabled
                      ? const Color(0xFF0D121F)
                      : const Color(0xFFA5ABB7),
                ),
                onChanged: onChanged,
                items: validItems
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
            ),
    );
  }

  // ── Styled text field ──────────────────────────────────────────────────────
  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: TextField(
        controller: controller,
        style: AppFont.style(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0D121F),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppFont.style(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA5ABB7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
