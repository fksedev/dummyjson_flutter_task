import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'primary_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.onRefresh,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
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
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 34.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 22.h),
              SizedBox(
                width: 180.w,
                child: PrimaryButton(label: actionLabel!, onPressed: onAction),
              ),
            ],
          ],
        ),
      ),
    );

    if (onRefresh == null) {
      return content;
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: content,
            ),
          );
        },
      ),
    );
  }
}