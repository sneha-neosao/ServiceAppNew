import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_color.dart';

class AppOutlineButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final double height;
  final double fontSize;

  const AppOutlineButtonWidget({
    required this.onPressed,
    required this.label,
    this.height = 60,
    this.fontSize = 17,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.white,
            foregroundColor: AppColor.green,
            side: BorderSide(color: AppColor.green, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            textStyle: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontSize: fontSize.sp),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
