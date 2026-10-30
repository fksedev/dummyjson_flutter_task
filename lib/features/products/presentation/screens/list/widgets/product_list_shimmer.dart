import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../shared/widgets/shimmer_box.dart';

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
            child: ShimmerScope(
              child: ShimmerBlock(
                width: double.infinity,
                height: 74.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.68,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ProductCardShimmer(),
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                child: ColoredBox(color: AppColors.skeleton),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBlock(width: double.infinity, height: 12.h),
                  SizedBox(height: 6.h),
                  ShimmerBlock(width: 90.w, height: 12.h),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      ShimmerBlock(width: 54.w, height: 14.h),
                      const Spacer(),
                      ShimmerBlock(width: 34.w, height: 12.h),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
