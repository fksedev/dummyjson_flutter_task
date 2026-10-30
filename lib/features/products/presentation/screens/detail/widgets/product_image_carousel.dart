import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({super.key, required this.images, this.heroTag});

  final List<String> images;
  final String? heroTag;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 340.h,
        alignment: Alignment.center,
        color: AppColors.skeleton,
        child: Icon(Icons.image_not_supported_outlined, size: 40.sp),
      );
    }

    return SizedBox(
      height: 340.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, index) {
              final page = CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.skeleton),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.skeleton,
                  alignment: Alignment.center,
                  child: Icon(Icons.broken_image_outlined, size: 40.sp),
                ),
              );
              if (index == 0 && widget.heroTag != null) {
                return Hero(tag: widget.heroTag!, child: page);
              }
              return page;
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 100.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.shadow.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              right: 16.w,
              bottom: 18.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_index + 1} / ${widget.images.length}',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
