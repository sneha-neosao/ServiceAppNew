import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/notifications/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:service_app/src/features/notifications/bloc/notifications_bloc/notifications_event.dart';
import 'package:service_app/src/features/notifications/bloc/mark_all_read_bloc/mark_all_read_bloc.dart';
import 'package:service_app/src/features/notifications/bloc/mark_all_read_bloc/mark_all_read_event.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class NotificationScreen extends StatefulWidget {
  final VoidCallback onBack;
  const NotificationScreen({super.key, required this.onBack});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime? _selectedDate;
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  late NotificationsBloc _notificationsBloc;
  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late MarkAllReadBloc _markAllReadBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _notificationsBloc = getIt<NotificationsBloc>();
    _customerBloc = getIt<CustomerBloc>()..add(const CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _markAllReadBloc = getIt<MarkAllReadBloc>()
      ..add(const MarkAllNotificationsReadEvent());
    _fetchNotifications(page: 1);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      final state = _notificationsBloc.state;
      if (state is NotificationsLoaded &&
          !state.hasReachedMax &&
          !_isFetchingMore) {
        setState(() => _isFetchingMore = true);
        final currentPage = state.response.data?.pagination?.page ?? 1;
        _fetchNotifications(page: currentPage + 1);
      }
    }
  }

  void _fetchNotifications({int page = 1}) {
    _notificationsBloc.add(
      GetNotificationsEvent(
        page: page,
        isRefresh: page == 1,
        customerName: _customerController.text.trim().isNotEmpty
            ? _customerController.text.trim()
            : null,
        siteName: _siteController.text.trim().isNotEmpty
            ? _siteController.text.trim()
            : null,
        date: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _customerController.dispose();
    _siteController.dispose();
    _scrollController.dispose();
    _customerBloc.close();
    _sitesBloc.close();
    _markAllReadBloc.close();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.colorFF1565C0, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchNotifications(page: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                      border: Border.all(color: AppColor.colorFFE5E7EB),
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
                        color: AppColor.colorFF5C616E,
                      ),
                      onPressed: widget.onBack,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'notif_header_title'.tr(),
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColor.colorFF0D121F,
                    ),
                  ),
                ],
              ),
            ),

            // ── Filters ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextInputField(
                          controller: _customerController,
                          hintText: 'close_call_customer_name_label'.tr(),
                          onSubmitted: () => _fetchNotifications(page: 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextInputField(
                          controller: _siteController,
                          hintText: 'site_name'.tr(),
                          onSubmitted: () => _fetchNotifications(page: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFilterField(
                    _selectedDate == null
                        ? 'notif_filter_date'.tr()
                        : DateFormat(
                            'dd MMM yyyy',
                            context.locale.languageCode,
                          ).format(_selectedDate!),
                    Icons.calendar_today_outlined,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _customerController.clear();
                        _siteController.clear();
                        _selectedDate = null;
                      });
                      _fetchNotifications(page: 1);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColor.colorFFF3F8FF,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: AppColor.colorFF1565C0,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'notif_clear_filters'.tr(),
                            style: AppFont.style(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColor.colorFF1565C0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColor.colorFFF1F2F6,
            ),

            // ── Notifications List ────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<NotificationsBloc, NotificationsState>(
                bloc: _notificationsBloc,
                listener: (context, state) {
                  if (state is NotificationsLoaded ||
                      state is NotificationsError) {
                    setState(() => _isFetchingMore = false);
                  }
                },
                builder: (context, state) {
                  if (state is NotificationsLoading ||
                      state is NotificationsInitial) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: _NotificationCardShimmer(),
                        );
                      },
                    );
                  } else if (state is NotificationsError) {
                    return Center(child: Text(state.message));
                  } else if (state is NotificationsLoaded) {
                    if (state.notifications.isEmpty) {
                      return RefreshIndicator(
                        color: AppColor.colorFF0B68B9,
                        onRefresh: () async {
                          _fetchNotifications(page: 1);
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            alignment: Alignment.center,
                            child: Text("no_notification".tr()),
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColor.colorFF0B68B9,
                      onRefresh: () async {
                        _fetchNotifications(page: 1);
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount:
                            state.notifications.length +
                            (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= state.notifications.length) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: _NotificationCardShimmer(),
                            );
                          }
                          final notification = state.notifications[index];
                          NotificationType type;
                          switch (notification.notificationType
                              ?.toLowerCase()) {
                            case 'complaint':
                              type = NotificationType.error;
                              break;
                            default:
                              type = NotificationType.info;
                          }

                          String formattedTime = '';
                          String formattedDate = '';
                          if (notification.createdAt != null) {
                            try {
                              final dt = DateTime.parse(
                                notification.createdAt!,
                              ).toLocal();
                              formattedTime = DateFormat(
                                'hh:mm a',
                                context.locale.languageCode,
                              ).format(dt);
                              formattedDate = DateFormat(
                                'd MMMM yyyy',
                                context.locale.languageCode,
                              ).format(dt);
                            } catch (e) {}
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _NotificationCard(
                              type: type,
                              title: notification.title ?? '',
                              description: notification.message ?? '',
                              tags: [
                                if (notification.customerName != null)
                                  notification.customerName!,
                                if (notification.siteName != null)
                                  notification.siteName!,
                              ],
                              time: formattedTime,
                              date: formattedDate,
                              isNew: !(notification.isRead ?? false),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onSubmitted,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.colorFFF1F2F6),
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSubmitted(),
        style: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColor.colorFF424B5C,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppFont.style(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColor.colorFFA5ABB7,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFilterField(String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.colorFFF1F2F6),
        ),
        child: Row(
          children: [
            // Icon(icon, size: 20, color: AppColor.colorFFA5ABB7),
            // const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _selectedDate == null
                      ? AppColor.colorFFA5ABB7
                      : AppColor.colorFF424B5C,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_month_outlined,
              color: AppColor.colorFFA5ABB7,
            ),
          ],
        ),
      ),
    );
  }
}

enum NotificationType { info, warning, success, error }

class _NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String description;
  final List<String> tags;
  final String time;
  final String date;
  final bool isNew;

  const _NotificationCard({
    required this.type,
    required this.title,
    required this.description,
    required this.tags,
    required this.time,
    required this.date,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor;
    IconData icon;
    Color iconBg;

    switch (type) {
      case NotificationType.info:
        accentColor = AppColor.colorFF1565C0;
        icon = Icons.info_outline;
        iconBg = AppColor.colorFFF1F8FF;
        break;
      case NotificationType.warning:
        accentColor = AppColor.colorFFF9A825;
        icon = Icons.error_outline;
        iconBg = AppColor.colorFFFFFDE7;
        break;
      case NotificationType.success:
        accentColor = AppColor.colorFF2E7D32;
        icon = Icons.check_circle_outline;
        iconBg = AppColor.colorFFE8F5E9;
        break;
      case NotificationType.error:
        accentColor = AppColor.colorFFD32F2F;
        icon = Icons.error_outline;
        iconBg = AppColor.colorFFFFEBEE;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color: isNew ? AppColor.colorFF1565C0 : Colors.transparent,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: iconBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: accentColor, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: AppFont.style(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColor.colorFF0D121F,
                                      ),
                                    ),
                                  ),
                                  // if (isNew)
                                  //   Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8,
                                  //       vertical: 4,
                                  //     ),
                                  //     decoration: BoxDecoration(
                                  //       color: AppColor.colorFF1565C0,
                                  //       borderRadius: BorderRadius.circular(6),
                                  //     ),
                                  //     child: Text(
                                  //       'notif_status_new'.tr(),
                                  //       style: AppFont.style(
                                  //         fontSize: 8,
                                  //         fontWeight: FontWeight.w800,
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                description,
                                style: AppFont.style(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.colorFF5C616E,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            runSpacing: 8,
                            children: tags
                                .map((tag) => _buildTag(tag))
                                .toList(),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _buildFooterItem(Icons.access_time, time),
                              const SizedBox(width: 16),
                              _buildFooterItem(
                                Icons.calendar_today_outlined,
                                date,
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.colorFFF8F9FB,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppFont.style(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColor.colorFF8E9BAE,
        ),
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColor.colorFFA5ABB7),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppFont.style(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColor.colorFF8E9BAE,
          ),
        ),
      ],
    );
  }
}

class _NotificationCardShimmer extends StatelessWidget {
  const _NotificationCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: Colors.transparent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: 40,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 14,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 14,
                                  width: 150,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 100,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 80,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
