import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/close_over_call_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_event.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_state.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';

class CloseOverCallDialog extends StatefulWidget {
  final String complaintId;
  final String complaintNo;
  final String customerName;
  final String siteName;
  final VoidCallback onSuccess;

  const CloseOverCallDialog({
    super.key,
    required this.complaintId,
    required this.complaintNo,
    required this.customerName,
    required this.siteName,
    required this.onSuccess,
  });

  @override
  State<CloseOverCallDialog> createState() => _CloseOverCallDialogState();
}

class _CloseOverCallDialogState extends State<CloseOverCallDialog> {
  final TextEditingController _resolutionController = TextEditingController();
  bool _isError = false;
  late CloseOverCallBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CloseOverCallBloc>();
  }

  void _submit() {
    if (_resolutionController.text.trim().length < 10) {
      setState(() {
        _isError = true;
      });
      return;
    }

    final params = CloseOverCallParams(
      complaintId: widget.complaintId,
      serviceCallDetails: _resolutionController.text.trim(),
    );
    _bloc.add(CloseOverCallPostEvent(params));
  }

  @override
  void dispose() {
    _bloc.close();
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
        child: SingleChildScrollView(
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
                        'close_call_dialog_title'.tr(),
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
                    child: _buildInfoColumn('Complaint No', widget.complaintNo),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'Customer Name',
                      widget.customerName,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn('Site Name', widget.siteName),
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
                  'close_call_resolution_label'.tr(),
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                SpeechToTextMicButton(controller: _resolutionController),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _resolutionController,
              minLines: 3,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: AppFont.style(fontSize: 14, color: Colors.black),
              onChanged: (val) {
                if (_isError && val.trim().length >= 10) {
                  setState(() => _isError = false);
                }
              },
              decoration: InputDecoration(
                hintText:
                    'close_call_resolution_hint'.tr(),
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
                  'close_call_min_chars'.tr(),
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
                    'close_call_cancel'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                BlocConsumer<CloseOverCallBloc, CloseOverCallState>(
                  bloc: _bloc,
                  listener: (context, state) {
                    if (state is CloseOverCallSuccessState) {
                      widget.onSuccess();

                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text(state.data.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is CloseOverCallFailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        if (state is! CloseOverCallLoadingState) {
                          _submit();
                        }
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1565C0,
                          ), // Make it primary blue when active
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (state is CloseOverCallLoadingState)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else
                              const Icon(
                                Icons.phone_disabled_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              'close_call_btn'.tr(),
                              style: AppFont.style(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
