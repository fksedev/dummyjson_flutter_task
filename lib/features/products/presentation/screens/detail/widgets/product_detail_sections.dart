import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/product.dart';

class ProductMetaRow extends StatelessWidget {
  const ProductMetaRow({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _Pill(
          icon: Icons.star_rounded,
          iconColor: AppColors.star,
          label: product.rating.toStringAsFixed(2),
          filled: true,
        ),
        _Pill(label: product.category),
        if (product.brand != null && product.brand!.isNotEmpty)
          _Pill(label: product.brand!),
      ],
    );
  }
}

class ProductPriceBlock extends StatelessWidget {
  const ProductPriceBlock({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentage > 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best price',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${product.discountedPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.mono(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                if (hasDiscount) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Was \$${product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.caption.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasDiscount)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                'Save ${product.discountPercentage.toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    this.icon,
    this.iconColor,
    this.filled = false,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: filled ? AppColors.primarySoft : AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: filled ? AppColors.primarySoft : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15.sp, color: iconColor ?? AppColors.textMuted),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
