import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';
import 'app_font.dart';

/// utility class to define the app theme
class AppTheme {
  AppTheme._();

  static ThemeData data(bool isDark) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,

      scaffoldBackgroundColor: isDark == true
          ? AppColor.black
          : AppColor.whiteShade,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 61.h)),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 26.w),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),

          /// 🔹 Background color
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return isDark
                  ? AppColor
                        .gray // dark disabled bg
                  : AppColor.gray; // light disabled bg
            }
            return AppColor.green; // enabled bg
          }),

          /// 🔹 Text & icon color
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return isDark ? AppColor.gray : AppColor.gray;
            }
            return AppColor.white; // enabled text/icon
          }),

          textStyle: MaterialStateProperty.all(AppFont.bold.s17),
        ),
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: AppFont.family,
      textTheme: TextTheme(
        bodySmall: AppFont.normal.s12.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyMedium: AppFont.normal.s14.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyLarge: AppFont.normal.s16.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        headlineSmall: AppFont.bold.s12.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        headlineMedium: AppFont.bold.s16.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        headlineLarge: AppFont.bold.s18.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        displaySmall: AppFont.bold.s22.copyWith(
          color: isDark ? Colors.white : Colors.black,
          height: 22 / 22,
        ),
        displayMedium: AppFont.bold.s25.copyWith(
          color: isDark ? Colors.white : Colors.black,
          height: 22 / 31,
        ),
        displayLarge: AppFont.bold.s30.copyWith(
          color: isDark ? Colors.white : Colors.black,
          height: 22 / 30,
        ),
      ),
    );
  }
}
