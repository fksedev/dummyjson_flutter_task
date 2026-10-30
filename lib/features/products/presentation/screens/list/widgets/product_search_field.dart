import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ProductSearchField extends StatefulWidget {
  const ProductSearchField({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged(value);
  }

  void _onClear() {
    _controller.clear();
    setState(() {});
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.mono(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: 'Search products (e.g. phone)',
        prefixIcon: Icon(Icons.search_rounded, size: 22.sp),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear',
                onPressed: _onClear,
                icon: Icon(Icons.close_rounded, size: 18.sp),
              ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
