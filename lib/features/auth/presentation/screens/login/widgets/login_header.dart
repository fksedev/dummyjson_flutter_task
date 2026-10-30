import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 30.sp,
          ),
        ),
        SizedBox(height: 28.h),
        Text(
          'DummyJSON',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text('Welcome back', style: AppTextStyles.display),
        SizedBox(height: 10.h),
        Text(
          'Sign in securely and explore a polished product catalog powered by DummyJSON.',
          style: AppTextStyles.body.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
