import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

enum ServiceCallType { ongoing, active, completed }

class ServiceCallCard extends StatelessWidget {
  final ServiceCallType type;
  final String complaintNo;
  final String companyName;
  final String location;
  final String? assignedTo;
  final bool isCompleted;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback? onSubmit;
  final VoidCallback? onCloseOverCall;

  const ServiceCallCard({
    super.key,
    required this.type,
    required this.complaintNo,
    required this.companyName,
    required this.location,
    this.assignedTo,
    this.isCompleted = false,
    required this.onView,
    required this.onEdit,
    this.onSubmit,
    this.onCloseOverCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    complaintNo,
                    style: AppFont.style(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                ),
                if (isCompleted) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                      child: Text(
                        'service_calls_btn_completed'.tr(),
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (type == ServiceCallType.ongoing) ...[
                  _buildIconButton(Icons.edit_outlined, onTap: onEdit),
                  const SizedBox(width: 8),
                ],
                _buildIconButton(Icons.visibility_outlined, onTap: onView),
              ],
            ),
            const SizedBox(height: 12),
            // Company Name
            Text(
              companyName,
              style: AppFont.style(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D121F),
              ),
            ),
            const SizedBox(height: 4),
            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFFA5ABB7),
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
            if (assignedTo != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Color(0xFF1565C0),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        assignedTo!,
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF424B5C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                if (type == ServiceCallType.active)
                  Expanded(
                    child: GestureDetector(
                      onTap: onCloseOverCall,
                      child: _buildSecondaryButton(
                        'service_calls_btn_close_over_call'.tr(),
                        Icons.phone_disabled_outlined,
                      ),
                    ),
                  ),
                if (type == ServiceCallType.completed)
                  Expanded(child: _buildCompletedButton()),
                if (type == ServiceCallType.active) const SizedBox(width: 12),
                if (type == ServiceCallType.ongoing ||
                    type == ServiceCallType.active)
                  Expanded(
                    child: GestureDetector(
                      onTap: onSubmit,
                      child: _buildPrimaryButton(
                        type == ServiceCallType.ongoing
                            ? 'service_calls_btn_submit'.tr()
                            : 'service_calls_btn_assign'.tr(),
                        type == ServiceCallType.ongoing
                            ? Icons.check_circle_outline
                            : Icons.person_outline,
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

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFFA5ABB7)),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, IconData icon) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String label, IconData icon) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5C616E)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5C616E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 18,
            color: Color(0xFFA5ABB7),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'service_calls_btn_completed'.tr(),
              style: AppFont.style(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
