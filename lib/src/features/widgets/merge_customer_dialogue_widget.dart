import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';

import '../../configs/injector/injector.dart';
import '../../core/theme/app_font.dart';
import '../common/bloc/create_new_customer_bloc/create_new_customer_event.dart';
import '../common/bloc/create_new_customer_bloc/create_new_customer_state.dart';
import '../common/domain/usecase/create_new_customer_usecase.dart';

class MergeCustomerDialogWidget extends StatelessWidget {
  final String name;
  final CreateNewCustomerBloc bloc;

  const MergeCustomerDialogWidget({
    super.key,
    required this.name,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNewCustomerBloc, CreateNewCustomerState>(
      bloc: bloc,
      listener: (ctx, state) {
        if (state is CreateNewCustomerSuccessState) {
          Navigator.pop(ctx); // Close dialog
          appSnackBar(
            context,
            const Color(0xFF4CAF50),
            state.data.message,
          );
          final newName = state.data.data?.name ?? name;
          // 🔹 Update your state here (customers list, ids, etc.)
        } else if (state is CreateNewCustomerFailureState) {
          Navigator.pop(ctx);
          appSnackBar(
            context,
            const Color(0xFFF44336),
            state.message,
          );
        }
      },
      builder: (ctx, state) {
        final isLoading = state is CreateNewCustomerLoadingState;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF7E6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_outline,
                          color: Color(0xFFFF9800), size: 32),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'merge_customer'.tr(),
                      style: AppFont.style(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'merge_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5C616E),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextButton(
                              onPressed: isLoading ? null : () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF6F6F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'no'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0D121F),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                bloc.add(
                                  CreateNewCustomerSubmitEvent(
                                    CreateNewCustomerParams(
                                      name: name,
                                      mergeExisting: true,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE65100),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                'yes'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Close icon
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: isLoading ? null : () => Navigator.pop(ctx),
                  child: const Icon(Icons.close, size: 20, color: Color(0xFFB0B8C8)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
