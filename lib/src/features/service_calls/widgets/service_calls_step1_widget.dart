part of '../presentation/pages/service_calls_screen.dart';

class ServiceCallsStep1Widget extends StatelessWidget {
  final _ServiceCallsScreenState parent;
  const ServiceCallsStep1Widget({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Service Calls Header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
          child: Row(
            children: [
              Text(
                'service_calls_title'.tr(),
                style: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColor.colorFF0D121F,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
