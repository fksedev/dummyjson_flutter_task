import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/app_error_state.dart';
import '../../../domain/entities/product.dart';
import '../../cubit/product_detail_cubit.dart';
import 'widgets/product_detail_content.dart';
import 'widgets/product_detail_shimmer.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, this.productId, this.product})
    : assert(productId != null || product != null);

  final int? productId;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    final id = productId ?? product!.id;
    return BlocProvider(
      create: (_) => sl<ProductDetailCubit>()..load(id, seed: product),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.status == ProductDetailStatus.loading) {
            return const ProductDetailShimmer();
          }

          if (state.status == ProductDetailStatus.failure ||
              state.product == null) {
            return SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  Expanded(
                    child: AppErrorState(
                      message: state.errorMessage ?? 'Failed to load product.',
                      onRetry: () => context.read<ProductDetailCubit>().retry(),
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              ProductDetailContent(product: state.product!),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                  child: Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.arrow_back_rounded,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: AppColors.shadow.withValues(alpha: 0.2),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Icon(icon, size: 20.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
