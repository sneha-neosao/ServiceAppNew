import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/database/offline_commissioning_db.dart';
import 'package:service_app/src/core/database/offline_service_reports_db.dart';
import 'package:service_app/src/features/offline/domain/services/offline_sync_service.dart';
import 'package:service_app/src/features/offline/domain/services/offline_service_sync_service.dart';
import 'package:service_app/src/core/network/network_checker.dart';
import 'package:service_app/src/core/theme/app_color.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class OfflineReportsScreen extends StatefulWidget {
  final bool isOnline;
  const OfflineReportsScreen({super.key, required this.isOnline});

  @override
  State<OfflineReportsScreen> createState() => _OfflineReportsScreenState();
}

class _OfflineReportsScreenState extends State<OfflineReportsScreen> {
  List<Map<String, dynamic>> _reports = [];
  bool _loading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _loading = true);
    List<Map<String, dynamic>> reports = [];
    if (_selectedTab == 0) {
      reports = await OfflineCommissioningDb.instance.getAllOfflineReports();
    } else if (_selectedTab == 1) {
      reports = await OfflineServiceReportsDb.instance.getAllOfflineReports();
    }
    if (mounted) {
      setState(() {
        _reports = reports;
        _loading = false;
      });
    }
  }

  /// Count how many steps (1–6) have data saved for this report
  int _stepsCompleted(Map<String, dynamic> report) {
    int count = 0;
    for (int i = 1; i <= 6; i++) {
      if (report['step$i'] != null) count++;
    }
    return count;
  }

  Future<void> _syncReport(String reportId) async {
    final isOnline = await NetworkInfo().checkIsConnected;
    if (!mounted) return;
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are offline. Connect to the internet to sync.'),
          backgroundColor: AppColor.bright_red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      ),
    );

    final result = _selectedTab == 0
        ? await getIt<OfflineSyncService>().syncReport(reportId)
        : await getIt<OfflineServiceSyncService>().syncReport(reportId);

    if (!mounted) return;
    Navigator.pop(context); // close loader

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColor.bright_red,
          ),
        );
      },
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report completely synced to server.'),
            backgroundColor: AppColor.green,
          ),
        );
        _loadReports(); // reload to remove it from the list
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF5C616E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Blue accent bar
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Offline Reports',
                          style: AppFont.style(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                      ),
                      // Online/Offline badge
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isOnline
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (widget.isOnline
                                          ? const Color(0xFF22C55E)
                                          : const Color(0xFFEF4444))
                                      .withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.isOnline ? 'Online' : 'Offline',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Subtitle info row
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Reports saved locally while offline',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // ── Segmented Tab Control ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment(
                        -1.0 +
                            (_selectedTab * (2.0 / 2)), // 2 is (tabCount - 1)
                        0,
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 1.0 / 3, // 3 tabs
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildSegmentTab(0, 'Commissioning')),
                        Expanded(child: _buildSegmentTab(1, 'Service Call')),
                        Expanded(child: _buildSegmentTab(2, 'AMC')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Body ───────────────────────────────────────────────────────
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    )
                  : (_selectedTab == 0
                      ? (_reports.isEmpty
                          ? _buildEmpty(
                              title: 'No Offline Commissioning Reports',
                              subtitle:
                                  'Commissioning reports saved while offline will appear here.',
                            )
                          : RefreshIndicator(
                              onRefresh: _loadReports,
                              color: AppColor.primaryColor,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: _reports.length,
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) =>
                                    _buildReportCard(_reports[index]),
                              ),
                            ))
                      : _selectedTab == 1
                          ? (_reports.isEmpty
                              ? _buildEmpty(
                                  title: 'No Offline Service Call Reports',
                                  subtitle:
                                      'Service call reports saved while offline will appear here.',
                                )
                              : RefreshIndicator(
                                  onRefresh: _loadReports,
                                  color: AppColor.primaryColor,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _reports.length,
                                    separatorBuilder: (_, index) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) =>
                                        _buildReportCard(_reports[index]),
                                  ),
                                ))
                          : _buildEmpty(
                              title: 'No Offline AMC Reports',
                              subtitle:
                                  'AMC reports saved while offline will appear here.',
                            )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentTab(int index, String label) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        _loadReports();
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Center(
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFA5ABB7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty({required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.cloud_done_rounded,
              size: 48,
              color: AppColor.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D121F),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final reportId = report['report_id'] as String? ?? '—';
    final commissioningWorkId =
        report['commissioning_work_id'] as String? ?? '—';
    final synced = (report['synced'] as int?) == 1;
    final stepsCompleted = _stepsCompleted(report);

    // Parse step1 for the agenda/technician names if available
    String subtitle = 'Report ID: ${_shortId(reportId)}';
    if (report['step1'] != null) {
      try {
        final step1 = jsonDecode(report['step1'] as String) as Map;
        final techs = step1['technicianNames'];
        if (techs is List && techs.isNotEmpty) {
          subtitle = techs.join(', ');
        }
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card top row ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: AppColor.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]!,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Work ID: ${_shortId(commissioningWorkId)}',
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400]!,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sync / Pending badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: synced
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    synced ? 'Synced' : 'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: synced
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFEA580C),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Step progress bar ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Steps completed',
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500]!,
                      ),
                    ),
                    Text(
                      '$stepsCompleted / 6',
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(6, (i) {
                    final filled = i < stepsCompleted;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: i < 5 ? 4 : 0),
                        decoration: BoxDecoration(
                          color: filled
                              ? AppColor.primaryColor
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // ── Divider + actions ────────────────────────────────────────
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F2F6)),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (synced || stepsCompleted < 6)
                        ? null
                        : () => _syncReport(reportId),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: (synced || stepsCompleted < 6)
                            ? Colors.grey[400]
                            : const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            synced
                                ? 'Synced'
                                : (stepsCompleted < 6
                                      ? 'Incomplete'
                                      : 'Sync Report'),
                            style: AppFont.style(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.sync_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
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

  /// Truncate long IDs to first 8 chars for display
  String _shortId(String id) {
    if (id.length <= 12) return id;
    return '${id.substring(0, 8)}…';
  }
}
