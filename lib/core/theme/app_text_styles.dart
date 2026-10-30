import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle mono({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize ?? 14.sp,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get display =>
      mono(fontSize: 28.sp, fontWeight: FontWeight.w700, height: 1.2);

  static TextStyle get title =>
      mono(fontSize: 20.sp, fontWeight: FontWeight.w700, height: 1.3);

  static TextStyle get subtitle =>
      mono(fontSize: 16.sp, fontWeight: FontWeight.w600, height: 1.35);

  static TextStyle get body => mono(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static TextStyle get caption => mono(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static TextStyle get button => mono(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );
}
