import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/product.dart';
import 'product_detail_sections.dart';
import 'product_image_carousel.dart';
import 'product_info_chips.dart';
import 'product_reviews_section.dart';
import 'product_tags.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final images = product.images.isNotEmpty
        ? product.images
        : (product.thumbnail.isNotEmpty ? [product.thumbnail] : <String>[]);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProductImageCarousel(
            images: images,
            heroTag: 'product-image-${product.id}',
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -22.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 36.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    product.title,
                    style: AppTextStyles.title.copyWith(height: 1.25),
                  ),
                  SizedBox(height: 12.h),
                  ProductMetaRow(product: product),
                  SizedBox(height: 18.h),
                  ProductPriceBlock(product: product),
                  SizedBox(height: 20.h),
                  Text('Overview', style: AppTextStyles.subtitle),
                  SizedBox(height: 10.h),
                  Text(
                    product.description,
                    style: AppTextStyles.body.copyWith(height: 1.6),
                  ),
                  SizedBox(height: 20.h),
                  ProductTags(tags: product.tags),
                  SizedBox(height: 20.h),
                  ProductInfoChips(product: product),
                  SizedBox(height: 12.h),
                  ProductReviewsSection(reviews: product.reviews),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
