import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class CloseOverCallDialog extends StatefulWidget {
  final String complaintNo;
  final String customerName;
  final String siteName;

  const CloseOverCallDialog({
    super.key,
    required this.complaintNo,
    required this.customerName,
    required this.siteName,
  });

  @override
  State<CloseOverCallDialog> createState() => _CloseOverCallDialogState();
}

class _CloseOverCallDialogState extends State<CloseOverCallDialog> {
  final TextEditingController _resolutionController = TextEditingController();
  bool _isError = false;

  void _submit() {
    if (_resolutionController.text.trim().length < 10) {
      setState(() {
        _isError = true;
      });
      return;
    }
    // TODO: integrate API for Close Over Call
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_disabled_outlined,
                    color: Color(0xFF1565C0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLOSE OVER CALL',
                        style: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      Text(
                        '${widget.complaintNo} - ${widget.customerName}',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFFA5ABB7),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Info Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F2F6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoColumn('COMPLAINT NO', widget.complaintNo),
                  ),
                  Expanded(
                    child: _buildInfoColumn('CUSTOMER NAME', widget.customerName),
                  ),
                  Expanded(
                    child: _buildInfoColumn('SITE NAME', widget.siteName),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Resolution Text Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resolution Details (Voice to Text Mandatory)',
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const Icon(
                  Icons.mic_off_outlined,
                  size: 16,
                  color: Color(0xFFA5ABB7),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _resolutionController,
              maxLines: 5,
              minLines: 3,
              style: AppFont.style(fontSize: 14, color: Colors.black),
              onChanged: (val) {
                if (_isError && val.trim().length >= 10) {
                  setState(() => _isError = false);
                }
              },
              decoration: InputDecoration(
                hintText: 'Mandatory: Summarize the resolution steps discussed over the call...',
                hintStyle: AppFont.style(
                  fontSize: 14,
                  color: const Color(0xFFD1D5DB),
                ),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isError ? Colors.red : const Color(0xFFE5E7EB),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isError ? Colors.red : const Color(0xFF1565C0),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: _isError ? Colors.red : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  'Minimum 10 characters required for closure',
                  style: AppFont.style(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _isError ? Colors.red : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8BAECE), // Similar to image
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phone_disabled_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CLOSE OVER CALL',
                          style: AppFont.style(
                            fontSize: 13,
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFont.style(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
