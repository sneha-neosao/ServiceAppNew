import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/bloc/check_feedback_bloc/check_feedback_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/check_feedback_bloc/check_feedback_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/check_feedback_bloc/check_feedback_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_check_feedback_bloc/service_call_check_feedback_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_check_feedback_bloc/service_call_check_feedback_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_check_feedback_bloc/service_call_check_feedback_state.dart';
import 'package:service_app/src/remote/models/feedback_model/feedback_response.dart';

class FeedbackDetailsScreen extends StatelessWidget {
  final String reportId;
  final String title;
  final bool isServiceCall;
  final VoidCallback onBack;

  const FeedbackDetailsScreen({
    super.key,
    required this.reportId,
    this.title = 'Commissioning Feedback Details',
    this.isServiceCall = false,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return isServiceCall
        ? BlocProvider(
            create: (_) =>
                getIt<ServiceCallCheckFeedbackBloc>()
                  ..add(FetchServiceCallCheckFeedbackEvent(reportId: reportId)),
            child: _buildScreen(context),
          )
        : BlocProvider(
            create: (_) =>
                getIt<CheckFeedbackBloc>()
                  ..add(FetchCheckFeedbackEvent(reportId: reportId)),
            child: _buildScreen(context),
          );
  }

  Widget _buildScreen(BuildContext context) {
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
                      title,
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
              child: isServiceCall
                  ? BlocBuilder<
                      ServiceCallCheckFeedbackBloc,
                      ServiceCallCheckFeedbackState
                    >(
                      builder: (context, state) {
                        if (state is ServiceCallCheckFeedbackLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ServiceCallCheckFeedbackError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: AppFont.style(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else if (state is ServiceCallCheckFeedbackLoaded) {
                          final data = state.response.data?.feedback;
                          if (data == null) {
                            return Center(
                              child: Text(
                                'No feedback found',
                                style: AppFont.style(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return _buildFeedbackContent(data);
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  : BlocBuilder<CheckFeedbackBloc, CheckFeedbackState>(
                      builder: (context, state) {
                        if (state is CheckFeedbackLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CheckFeedbackError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: AppFont.style(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else if (state is CheckFeedbackLoaded) {
                          final data = state.response.data?.feedback;
                          if (data == null) {
                            return Center(
                              child: Text(
                                'No feedback found',
                                style: AppFont.style(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return _buildFeedbackContent(data);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackContent(FeedbackDetails data) {
    return ListView(
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
                iconColor: const Color(0xFF6B4EFF),
                title: 'Customer Name',
                valueWidget: Text(
                  data.name,
                  style: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

              _buildRow(
                icon: Icons.phone_outlined,
                iconColor: const Color(0xFF00BFA5),
                title: 'Contact Number',
                valueWidget: Text(
                  data.contactNumber,
                  style: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

              _buildRow(
                icon: Icons.verified_user_outlined,
                iconColor: const Color(0xFF00C853),
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
                      color: data.issueResolved
                          ? const Color(0xFF00C853)
                          : Colors.red,
                    ),
                  ),
                  child: Text(
                    data.issueResolved ? 'Yes' : 'No',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: data.issueResolved
                          ? const Color(0xFF00C853)
                          : Colors.red,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

              _buildRow(
                icon: Icons.star_outline,
                iconColor: const Color(0xFFFF9800),
                title: 'Customer Rating',
                valueWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < data.rating ? Icons.star : Icons.star_border,
                      color: index < data.rating
                          ? const Color(0xFFFF9800)
                          : const Color(0xFFE0E0E0),
                      size: 20,
                    );
                  }),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

              _buildRow(
                icon: Icons.workspace_premium_outlined,
                iconColor: const Color(0xFF2962FF),
                title: 'Technician Behavior',
                valueWidget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF00C853)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.technicianBehavior.toLowerCase() == 'good'
                            ? '👍'
                            : (data.technicianBehavior.toLowerCase() ==
                                      'excellent'
                                  ? '🌟'
                                  : '💬'),
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data.technicianBehavior,
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
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

              _buildCommentRow(
                icon: Icons.chat_bubble_outline,
                iconColor: const Color(0xFF9C27B0),
                title: 'Short Comment',
                comment: data.shortComment,
              ),
            ],
          ),
        ),
      ],
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
              comment.isNotEmpty ? comment : 'No comment provided',
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
