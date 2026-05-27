import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class AmcScheduleScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String title, String location, String visitInfo, String window) onItemTap;
  const AmcScheduleScreen({super.key, required this.onBack, required this.onItemTap});

  @override
  State<AmcScheduleScreen> createState() => _AmcScheduleScreenState();
}

class _AmcScheduleScreenState extends State<AmcScheduleScreen> {
  // ── Dropdown data ──────────────────────────────────────────────────────────
  final List<String> _customers = ['All', 'Global Infotech', 'Reliance Mart', 'Tata Motors', 'Wipro', 'Infosys'];
  final List<String> _sites     = ['All', 'Main Server Room', 'Chiller Plant', 'Assembly Line 4', 'Data Center B', 'Pantry Area'];

  // ── State ──────────────────────────────────────────────────────────────────
  bool   _customerOpen     = false;
  bool   _siteOpen         = false;
  String _customerSearch   = '';
  String _siteSearch       = '';
  String _selectedCustomer = 'Select Customer';
  String _selectedSite     = 'Select Site';

  List<String> get _filteredCustomers => _customers
      .where((c) => c.toLowerCase().contains(_customerSearch.toLowerCase()))
      .toList();

  List<String> get _filteredSites => _sites
      .where((s) => s.toLowerCase().contains(_siteSearch.toLowerCase()))
      .toList();

  void _toggleCustomer() => setState(() {
        _customerOpen = !_customerOpen;
        _siteOpen = false;
        _customerSearch = '';
      });

  void _toggleSite() => setState(() {
        _siteOpen = !_siteOpen;
        _customerOpen = false;
        _siteSearch = '';
      });

  void _selectCustomer(String v) => setState(() {
        _selectedCustomer = v;
        _customerOpen = false;
      });

  void _selectSite(String v) => setState(() {
        _selectedSite = v;
        _siteOpen = false;
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF5C616E)),
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'amc_schedule_appbar_title'.tr(),
                    style: AppFont.style(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  Text(
                    'amc_schedule_subtitle'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Dropdowns + List ──────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [

              // ── Customer dropdown ────────────────────────────────────────
              _DropdownTrigger(
                label: _selectedCustomer,
                isPlaceholder: _selectedCustomer == 'Select Customer',
                isOpen: _customerOpen,
                onTap: _toggleCustomer,
              ),
              if (_customerOpen) ...[
                const SizedBox(height: 6),
                _DropdownPanel(
                  searchValue: _customerSearch,
                  onSearchChanged: (v) => setState(() => _customerSearch = v),
                  items: _filteredCustomers,
                  onSelect: _selectCustomer,
                ),
              ],

              const SizedBox(height: 12),

              // ── Site dropdown ────────────────────────────────────────────
              _DropdownTrigger(
                label: _selectedSite,
                isPlaceholder: _selectedSite == 'Select Site',
                isOpen: _siteOpen,
                onTap: _toggleSite,
              ),
              if (_siteOpen) ...[
                const SizedBox(height: 6),
                _DropdownPanel(
                  searchValue: _siteSearch,
                  onSearchChanged: (v) => setState(() => _siteSearch = v),
                  items: _filteredSites,
                  onSelect: _selectSite,
                ),
              ],

              const SizedBox(height: 20),

              // ── Schedule cards ───────────────────────────────────────────
              _AmcScheduleCard(
                title: 'Infosys Campus',
                location: 'Data Center B',
                visitInfo: 'Visit 1 of 4',
                window: 'Apr 29 - May 05',
                onTap: () => widget.onItemTap(
                    'Infosys Campus', 'Data Center B', 'Visit 1 of 4', 'Apr 29 - May 05'),
              ),
              const SizedBox(height: 20),
              _AmcScheduleCard(
                title: 'Wipro Office',
                location: 'Pantry Area',
                visitInfo: 'Visit 2 of 6',
                window: 'Apr 30 - May 10',
                onTap: () => widget.onItemTap(
                    'Wipro Office', 'Pantry Area', 'Visit 2 of 6', 'Apr 30 - May 10'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Dropdown trigger ───────────────────────────────────────────────────────────
class _DropdownTrigger extends StatelessWidget {
  final String label;
  final bool isPlaceholder;
  final bool isOpen;
  final VoidCallback onTap;

  const _DropdownTrigger({
    required this.label,
    required this.isPlaceholder,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isPlaceholder
                      ? const Color(0xFFA5ABB7)
                      : const Color(0xFF0D121F),
                ),
              ),
            ),
            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFFA5ABB7),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dropdown panel (search + scrollable list) ──────────────────────────────────
class _DropdownPanel extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<String> items;
  final ValueChanged<String> onSelect;

  const _DropdownPanel({
    required this.searchValue,
    required this.onSearchChanged,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search box ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF0D121F)),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA5ABB7)),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFA5ABB7), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // ── Items ──────────────────────────────────────────────────────
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => onSelect(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Text(
                        item,
                        style: AppFont.style(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Schedule card ──────────────────────────────────────────────────────────────
class _AmcScheduleCard extends StatelessWidget {
  final String title;
  final String location;
  final String visitInfo;
  final String window;
  final VoidCallback onTap;

  const _AmcScheduleCard({
    required this.title,
    required this.location,
    required this.visitInfo,
    required this.window,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppFont.style(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 16, color: Color(0xFF1565C0)),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: AppFont.style(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF424B5C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'amc_schedule_status_active'.tr(),
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFF1F2F6)),
              const SizedBox(height: 20),
              // Info Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'amc_schedule_visit_info'.tr(),
                          style: AppFont.style(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visitInfo,
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'amc_schedule_window'.tr(),
                          style: AppFont.style(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          window,
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
