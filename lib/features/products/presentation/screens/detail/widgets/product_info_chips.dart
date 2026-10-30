import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/product.dart';

class ProductInfoChips extends StatelessWidget {
  const ProductInfoChips({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, Color)>[
      (Icons.inventory_2_outlined, 'Stock ${product.stock}', AppColors.primary),
      if (product.availabilityStatus != null)
        (
          Icons.verified_outlined,
          product.availabilityStatus!,
          AppColors.success,
        ),
      if (product.sku != null && product.sku!.isNotEmpty)
        (Icons.qr_code_2_rounded, 'SKU ${product.sku}', AppColors.accent),
      if (product.minimumOrderQuantity != null)
        (
          Icons.shopping_basket_outlined,
          'Min. order ${product.minimumOrderQuantity}',
          AppColors.textSecondary,
        ),
      if (product.weight != null)
        (
          Icons.scale_outlined,
          'Weight ${product.weight}',
          AppColors.textSecondary,
        ),
      if (product.dimensions != null)
        (
          Icons.straighten_rounded,
          'Size ${product.dimensions!.label}',
          AppColors.textSecondary,
        ),
      if (product.shippingInformation != null)
        (
          Icons.local_shipping_outlined,
          product.shippingInformation!,
          AppColors.textSecondary,
        ),
      if (product.warrantyInformation != null)
        (
          Icons.shield_outlined,
          product.warrantyInformation!,
          AppColors.textSecondary,
        ),
      if (product.returnPolicy != null)
        (
          Icons.assignment_return_outlined,
          product.returnPolicy!,
          AppColors.textSecondary,
        ),
      if (product.barcode != null && product.barcode!.isNotEmpty)
        (
          Icons.qr_code_scanner_rounded,
          'Barcode ${product.barcode}',
          AppColors.textSecondary,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details', style: AppTextStyles.subtitle),
        SizedBox(height: 10.h),
        for (final item in items)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(item.$1, size: 18.sp, color: item.$3),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    item.$2,
                    style: AppTextStyles.mono(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
