import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/app_empty_state.dart';
import '../../../../../shared/widgets/app_error_state.dart';
import '../../../../auth/presentation/widgets/user_avatar_button.dart';
import '../../cubit/product_list_cubit.dart';
import '../detail/product_detail_screen.dart';
import 'widgets/product_list_body.dart';
import 'widgets/product_list_shimmer.dart';
import 'widgets/product_search_field.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListCubit>()..loadInitial(),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop',
              style: AppTextStyles.mono(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            BlocBuilder<ProductListCubit, ProductListState>(
              buildWhen: (p, c) =>
                  p.total != c.total ||
                  p.status != c.status ||
                  p.query != c.query ||
                  p.products.length != c.products.length,
              builder: (context, state) {
                final label = state.isSearching
                    ? (state.total > 0
                          ? '${state.total} results for "${state.query}"'
                          : 'Searching "${state.query}"')
                    : (state.total > 0
                          ? '${state.products.length} loaded · ${state.total} total'
                          : 'DummyJSON catalog');
                return Text(label, style: AppTextStyles.caption);
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: const UserAvatarButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
            child: ProductSearchField(
              onChanged: context.read<ProductListCubit>().onQueryChanged,
              onClear: context.read<ProductListCubit>().clearSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, state) {
                if (state.isInitialLoading) {
                  return const ProductListShimmer();
                }

                if (state.status == ProductListStatus.failure &&
                    state.products.isEmpty) {
                  return AppErrorState(
                    message: state.errorMessage ?? 'Failed to load products.',
                    onRetry: () =>
                        context.read<ProductListCubit>().loadInitial(),
                    onRefresh: () => context.read<ProductListCubit>().refresh(),
                  );
                }

                if (state.status == ProductListStatus.empty) {
                  return AppEmptyState(
                    title: state.isSearching
                        ? 'No matches found'
                        : 'No products yet',
                    message: state.isSearching
                        ? 'Try another keyword or clear search.'
                        : 'Pull to refresh or tap Refresh to try again.',
                    actionLabel: state.isSearching ? 'Clear search' : 'Refresh',
                    onAction: state.isSearching
                        ? () => context.read<ProductListCubit>().clearSearch()
                        : () => context.read<ProductListCubit>().refresh(),
                    onRefresh: () => context.read<ProductListCubit>().refresh(),
                  );
                }

                return ProductListBody(
                  state: state,
                  onRefresh: () => context.read<ProductListCubit>().refresh(),
                  onLoadMore: () => context.read<ProductListCubit>().loadMore(),
                  onOpenProduct: (product) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
