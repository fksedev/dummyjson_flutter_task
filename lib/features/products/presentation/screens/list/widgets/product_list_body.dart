import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/product.dart';
import '../../../cubit/product_list_cubit.dart';
import 'product_card.dart';
import 'product_list_shimmer.dart';

class ProductListBody extends StatelessWidget {
  const ProductListBody({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onOpenProduct,
  });

  final ProductListState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final ValueChanged<Product> onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 280) {
            onLoadMore();
          }
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                child: _IntroBanner(total: state.total, query: state.query),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => onOpenProduct(product),
                  );
                }, childCount: state.products.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 28.h),
                child: _Footer(state: state, onRetry: onLoadMore),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroBanner extends StatelessWidget {
  const _IntroBanner({required this.total, required this.query});

  final int total;
  final String query;

  @override
  Widget build(BuildContext context) {
    final searching = query.trim().isNotEmpty;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primarySoft, Color(0xFFE7F4FA)],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              searching
                  ? Icons.search_rounded
                  : Icons.auto_awesome_mosaic_rounded,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  searching ? 'Search results' : 'Curated picks',
                  style: AppTextStyles.mono(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  searching
                      ? '$total matches for "$query"'
                      : (total > 0
                            ? 'Explore $total DummyJSON products'
                            : 'Fresh finds for your next project'),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onRetry});

  final ProductListState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.status == ProductListStatus.loadingMore) {
      return SizedBox(
        height: 240.h,
        child: Row(
          children: [
            const Expanded(child: ProductCardShimmer()),
            SizedBox(width: 12.w),
            const Expanded(child: ProductCardShimmer()),
          ],
        ),
      );
    }

    if (state.loadMoreError != null) {
      return Column(
        children: [
          Text(
            state.loadMoreError!,
            style: AppTextStyles.caption.copyWith(color: AppColors.danger),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    }

    if (!state.hasMore) {
      return Text(
        'Showing ${state.products.length} of ${state.total}',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption,
      );
    }

    return SizedBox(height: 12.h);
  }
}
