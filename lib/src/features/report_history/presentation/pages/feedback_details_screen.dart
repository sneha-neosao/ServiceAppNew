import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class FeedbackDetailsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const FeedbackDetailsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Section ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
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
                          color: Colors.black.withValues(alpha: 0.04),
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
                      onPressed: onBack,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Commissioning Feedback Details',
                      style: AppFont.style(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

            // ── Content ───────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F2F6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildRow(
                          icon: Icons.person_outline,
                          iconColor: const Color(0xFF6B4EFF), // Purple
                          title: 'Customer Name',
                          valueWidget: Text(
                            'Vhsgw', // Dummy data per the image
                            style: AppFont.style(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF212121),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F2F6),
                        ),

                        _buildRow(
                          icon: Icons.phone_outlined,
                          iconColor: const Color(0xFF00BFA5), // Teal
                          title: 'Contact Number',
                          valueWidget: Text(
                            '8546499969',
                            style: AppFont.style(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF212121),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F2F6),
                        ),

                        _buildRow(
                          icon: Icons.verified_user_outlined,
                          iconColor: const Color(0xFF00C853), // Green
                          title: 'Was the issue resolved?',
                          valueWidget: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF00C853),
                              ),
                            ),
                            child: Text(
                              'Yes',
                              style: AppFont.style(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF00C853),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F2F6),
                        ),

                        _buildRow(
                          icon: Icons.star_outline,
                          iconColor: const Color(0xFFFF9800), // Orange
                          title: 'Customer Rating',
                          valueWidget: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < 3 ? Icons.star : Icons.star_border,
                                color: index < 3
                                    ? const Color(0xFFFF9800)
                                    : const Color(0xFFE0E0E0),
                                size: 20,
                              );
                            }),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F2F6),
                        ),

                        _buildRow(
                          icon: Icons.workspace_premium_outlined,
                          iconColor: const Color(0xFF2962FF), // Blue
                          title: 'Technician Behavior',
                          valueWidget: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF00C853),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '👍',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Good',
                                  style: AppFont.style(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF00C853),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F2F6),
                        ),

                        _buildCommentRow(
                          icon: Icons.chat_bubble_outline,
                          iconColor: const Color(0xFF9C27B0), // Purple
                          title: 'Short Comment',
                          comment: 'Hehsuisj',
                        ),
                      ],
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

  Widget _buildRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF757575), // Greyish label
              ),
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildCommentRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF757575),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              comment,
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF212121),
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
