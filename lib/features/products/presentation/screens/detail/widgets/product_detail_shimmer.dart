import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../shared/widgets/shimmer_box.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Column(
        children: [
          ShimmerBlock(
            width: double.infinity,
            height: 340.h,
            borderRadius: BorderRadius.zero,
          ),
          Transform.translate(
            offset: Offset(0, -22.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ShimmerBlock(
                      width: 42.w,
                      height: 4.h,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  ShimmerBlock(width: double.infinity, height: 22.h),
                  SizedBox(height: 8.h),
                  ShimmerBlock(width: 200.w, height: 22.h),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      ShimmerBlock(
                        width: 70.w,
                        height: 28.h,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      SizedBox(width: 8.w),
                      ShimmerBlock(
                        width: 90.w,
                        height: 28.h,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  ShimmerBlock(
                    width: double.infinity,
                    height: 88.h,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  SizedBox(height: 18.h),
                  ShimmerBlock(width: 120.w, height: 18.h),
                  SizedBox(height: 10.h),
                  ShimmerBlock(width: double.infinity, height: 12.h),
                  SizedBox(height: 8.h),
                  ShimmerBlock(width: double.infinity, height: 12.h),
                  SizedBox(height: 8.h),
                  ShimmerBlock(width: 240.w, height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
