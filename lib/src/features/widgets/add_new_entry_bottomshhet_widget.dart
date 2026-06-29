import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddNewEntryBottomSheet extends StatelessWidget {
  final String title;
  final String label;
  final String hint;
  final bool isLoading;
  final VoidCallback onClose;
  final ValueChanged<String> onSubmit;

  const AddNewEntryBottomSheet({
    super.key,
    required this.title,
    required this.label,
    required this.hint,
    required this.isLoading,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return SafeArea(
      bottom: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0D121F),
                  ),
                ),
                GestureDetector(
                  onTap: isLoading ? null : onClose,
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

            // Label
            Text(
              label,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: Color(0xFFA5ABB7),
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 8),

            // TextField
            TextField(
              controller: controller,
              autofocus: true,
              enabled: !isLoading,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA5ABB7),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F9FB),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    onSubmit(text);
                  }
                },
                icon: isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.save_outlined, size: 18),
                label: isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    :  Text(
                  'save_entry'.tr(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
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
      ),
    );
  }
}
