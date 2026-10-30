import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/session_cubit.dart';

class UserAvatarButton extends StatelessWidget {
  const UserAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        final user = state.user;
        return PopupMenuButton<String>(
          tooltip: user?.displayName ?? 'Account',
          offset: Offset(0, 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          onSelected: (value) async {
            final messenger = ScaffoldMessenger.of(context);
            final session = context.read<SessionCubit>();

            if (value == 'logout') {
              await session.logout();
              return;
            }

            if (value == 'refresh') {
              final ok = await session.refreshSession();
              if (!context.mounted) return;
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    ok
                        ? 'Session refreshed successfully.'
                        : 'Could not refresh session. Please sign in again.',
                  ),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            if (user != null)
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: AppTextStyles.mono(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text('@${user.username}', style: AppTextStyles.caption),
                    if (user.email.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(user.email, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Refresh session',
                    style: AppTextStyles.mono(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 18.sp,
                    color: AppColors.danger,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Sign out',
                    style: AppTextStyles.mono(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: _Avatar(imageUrl: user?.image, name: user?.displayName),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl, this.name});

  final String? imageUrl;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final initial = (name != null && name!.isNotEmpty)
        ? name![0].toUpperCase()
        : '?';

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        color: AppColors.primarySoft,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Text(
                  initial,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  initial,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                initial,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }
}
