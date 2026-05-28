import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

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
  final List<String> _customers = ['Global Infotech', 'Reliance Mart', 'Tech Corp'];
  String? _selectedCustomer;

  // ── Site / Location ───────────────────────────────────────────────────────
  final List<String> _sites = ['Main Server Room', 'Chiller Plant', 'Roof Top'];
  String? _selectedSite;

  // ── Equipment ─────────────────────────────────────────────────────────────
  final List<String> _equipments = ['HVAC Cooling', 'Pump System', 'Generator'];
  String? _selectedEquipment;

  // ── Technicians ───────────────────────────────────────────────────────────
  final List<String> _technicians = [
    'Vinod Patil',
    'Prashant Shinde',
    'Rahul Deshmukh',
    'Amit Kumar',
  ];
  String? _selectedTechnician;

  @override
  void initState() {
    super.initState();

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

    // ── Equipment ─────────────────────────────────────────────────────────────
    _selectedEquipment = (widget.initialEquipment != null &&
            _equipments.contains(widget.initialEquipment))
        ? widget.initialEquipment
        : null;

    // ── Technician — only set if the value exists as a single list item ───────
    // initialTechnicians may be a comma-joined string like "A, B"; guard it.
    _selectedTechnician = (widget.initialTechnicians != null &&
            _technicians.contains(widget.initialTechnicians))
        ? widget.initialTechnicians
        : null;
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
                      child: const Icon(Icons.close, size: 16, color: Color(0xFFA5ABB7)),
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
                      horizontal: 16, vertical: 14),
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
                        color: Color(0xFF1565C0), width: 1.5),
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
                    backgroundColor: const Color(0xFF1565C0), // matching the blue
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
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFF1F2F6)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            size: 16, color: Color(0xFF0D121F)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      widget.initialCustomer != null
                          ? 'Edit Commissioning Job'
                          : 'Add Commissioning Job',
                      style: AppFont.style(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

              // ── Form body ────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── SELECT CUSTOMER ────────────────────────────────
                      _buildSectionHeader(
                        label: 'SELECT CUSTOMER',
                        onAddTap: () => _showAddBottomSheet(
                          fieldLabel: 'Customer',
                          list: _customers,
                          onSaved: (val) => setState(() {
                            _customers.insert(0, val);
                            _selectedCustomer = val;
                          }),
                        ),
                      ),
                      _buildDropdown(
                        hint: 'Choose customer...',
                        value: _selectedCustomer,
                        items: _customers,
                        onChanged: (v) =>
                            setState(() => _selectedCustomer = v),
                      ),

                      const SizedBox(height: 24),

                      // ── SELECT SITE ────────────────────────────────────
                      _buildSectionHeader(
                        label: 'SELECT SITE / LOCATION',
                        onAddTap: () => _showAddBottomSheet(
                          fieldLabel: 'Site',
                          list: _sites,
                          onSaved: (val) => setState(() {
                            _sites.insert(0, val);
                            _selectedSite = val;
                          }),
                        ),
                      ),
                      _buildDropdown(
                        hint: 'Choose site...',
                        value: _selectedSite,
                        items: _sites,
                        onChanged: (v) =>
                            setState(() => _selectedSite = v),
                      ),

                      const SizedBox(height: 24),

                      // ── SELECT EQUIPMENT ───────────────────────────────
                      _buildSectionHeader(
                        label: 'SELECT EQUIPMENT',
                        showAdd: false,
                      ),
                      _buildDropdown(
                        hint: 'Choose equipment...',
                        value: _selectedEquipment,
                        items: _equipments,
                        onChanged: (v) =>
                            setState(() => _selectedEquipment = v),
                      ),

                      const SizedBox(height: 24),

                      // ── SELECT TECHNICIAN ──────────────────────────────
                      _buildSectionHeader(
                        label: 'ASSIGN TECHNICIAN',
                        showAdd: false,
                      ),
                      _buildDropdown(
                        hint: 'Choose technician...',
                        value: _selectedTechnician,
                        items: _technicians,
                        onChanged: (v) =>
                            setState(() => _selectedTechnician = v),
                      ),

                      const SizedBox(height: 40),

                      // ── Assign Button ──────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _onAssign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ASSIGN JOB',
                                style: AppFont.style(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
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

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFont.style(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFA5ABB7),
              letterSpacing: 0.7,
            ),
          ),
          if (showAdd && onAddTap != null)
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add, size: 18, color: Color(0xFF1565C0)),
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
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFA5ABB7),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Color(0xFFA5ABB7)),
          dropdownColor: Colors.white,
          style: AppFont.style(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D121F),
          ),
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ),
    );
  }
}
