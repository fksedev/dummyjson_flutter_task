import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.07),
                blurRadius: 20,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product-image-${product.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(22.r),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: product.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: AppColors.skeleton),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.skeleton,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 28.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: _Badge(label: product.category),
                    ),
                    if (product.discountPercentage > 0)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: _Badge(
                          label:
                              '-${product.discountPercentage.toStringAsFixed(0)}%',
                          tone: _BadgeTone.success,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mono(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          '\$${product.discountedPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.mono(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.star_rounded,
                          size: 15.sp,
                          color: AppColors.star,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _BadgeTone { soft, success }

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.tone = _BadgeTone.soft});

  final String label;
  final _BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final soft = tone == _BadgeTone.soft;
    return Container(
      constraints: BoxConstraints(maxWidth: 110.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: soft
            ? AppColors.surface.withValues(alpha: 0.92)
            : AppColors.successSoft,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: soft ? AppColors.primaryDark : AppColors.success,
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
