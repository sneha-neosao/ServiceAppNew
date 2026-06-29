import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/home/bloc/upcoming_amc_bloc/upcoming_amc_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class UpcomingAmcCard extends StatelessWidget {
  final UpcomingAmcBloc upcomingAmcBloc;
  final VoidCallback onScheduleTap;

  const UpcomingAmcCard({
    super.key,
    required this.upcomingAmcBloc,
    required this.onScheduleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.colorFFFDF5E6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColor.colorFFD38C22,
                  size: 24,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'home_amc_card_title'.tr(),
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColor.colorFF0A2342,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              UpcomingAmcDropdownPill(
                label: 'home_amc_card_dropdown'.tr(),
                onChanged: (val) {
                  upcomingAmcBloc.add(UpcomingAmcGetEvent(val));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColor.colorFFFDF8E8,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<UpcomingAmcBloc, UpcomingAmcState>(
                      bloc: upcomingAmcBloc,
                      builder: (context, state) {
                        if (state is UpcomingAmcLoadingState) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        } else if (state is UpcomingAmcSuccessState) {
                          return Text(
                            '${state.data.data?.total ?? 0}',
                            style: AppFont.style(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: AppColor.colorFFD38C22,
                            ),
                          );
                        }
                        return Text(
                          '0',
                          style: AppFont.style(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColor.colorFFD38C22,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'home_amc_total_label'.tr(),
                      style: AppFont.style(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColor.colorFF985A05,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onScheduleTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: AppColor.colorFFD38C22,
                      size: 22,
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
}

class UpcomingAmcDropdownPill extends StatefulWidget {
  final String label;
  final ValueChanged<String>? onChanged;
  const UpcomingAmcDropdownPill({
    required this.label,
    this.onChanged,
    super.key,
  });
  @override
  State<UpcomingAmcDropdownPill> createState() =>
      _UpcomingAmcDropdownPillState();
}

class _UpcomingAmcDropdownPillState extends State<UpcomingAmcDropdownPill> {
  String? _selectedOption;
  final List<String> _options = ['Today', 'Tomorrow', 'Week', 'Month'];

  String _getTranslation(String opt) {
    switch (opt) {
      case 'Today':
        return 'filter_today'.tr();
      case 'Tomorrow':
        return 'filter_tomorrow'.tr();
      case 'Week':
        return 'filter_week'.tr();
      case 'Month':
        return 'filter_month'.tr();
      default:
        return opt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      onSelected: (val) {
        setState(() => _selectedOption = val);
        if (widget.onChanged != null) {
          widget.onChanged!(val);
        }
      },
      offset: const Offset(0, 45),
      itemBuilder: (ctx) => _options
          .map(
            (opt) => PopupMenuItem(
              value: opt,
              child: Text(
                _getTranslation(opt),
                style: AppFont.style(color: Colors.black, fontSize: 12),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.colorFFF8F9FB,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.colorFFF1F2F6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedOption == null
                  ? widget.label
                  : _getTranslation(_selectedOption!),
              style: AppFont.style(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColor.colorFF0A2342,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColor.colorFFA5ABB7,
            ),
          ],
        ),
      ),
    );
  }
}
