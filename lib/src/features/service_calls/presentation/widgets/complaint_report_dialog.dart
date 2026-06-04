import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class ComplaintReportDialog extends StatelessWidget {
  final String complaintNo;
  final String date;
  final String client;
  final String site;
  final String issue;

  const ComplaintReportDialog({
    super.key,
    required this.complaintNo,
    required this.date,
    required this.client,
    required this.site,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'complaint_report_title'.tr(),
                  style: AppFont.style(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFA5ABB7)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Info Grid
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'complaint_report_no_label'.tr(),
                    complaintNo,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'complaint_report_received_label'.tr(),
                    date,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoItem('complaint_report_client_label'.tr(), client),
            const SizedBox(height: 24),
            _buildInfoItem('complaint_report_site_label'.tr(), site),
            const SizedBox(height: 32),
            // Issue Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'complaint_report_issue_label'.tr(),
                    style: AppFont.style(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    issue,
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF424B5C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Download Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_download_outlined, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'complaint_report_btn_download'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0D121F),
          ),
        ),
      ],
    );
  }
}
