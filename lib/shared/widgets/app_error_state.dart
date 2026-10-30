import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'primary_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.onRefresh,
  });

  final String message;
  final VoidCallback onRetry;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color: AppColors.dangerSoft,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 34.sp,
                color: AppColors.danger,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Something went wrong',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: 160.w,
              child: PrimaryButton(label: 'Try again', onPressed: onRetry),
            ),
          ],
        ),
      ),
    );

    if (onRefresh == null) return content;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(height: constraints.maxHeight, child: content),
          );
        },
      ),
    );
  }
}
