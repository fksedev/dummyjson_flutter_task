import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/product.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key, required this.reviews});

  final List<ProductReview> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews (${reviews.length})', style: AppTextStyles.subtitle),
        SizedBox(height: 10.h),
        for (final review in reviews) ...[
          _ReviewCard(review: review),
          SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  review.reviewerName.isNotEmpty
                      ? review.reviewerName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: AppTextStyles.mono(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.star_rounded, size: 14.sp, color: AppColors.star),
              SizedBox(width: 2.w),
              Text(
                '${review.rating}',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.comment,
            style: AppTextStyles.body.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}
