import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_dimens.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
import 'features/auth/presentation/screens/login/login_screen.dart';
import 'features/products/presentation/screens/list/product_list_screen.dart';
import 'features/products/presentation/screens/list/widgets/product_list_shimmer.dart';

class DummyJsonApp extends StatelessWidget {
  const DummyJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(AppDimens.designWidth, AppDimens.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return BlocProvider.value(
          value: sl<SessionCubit>(),
          child: MaterialApp(
            title: 'DummyJSON Task',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const _SessionGate(),
          ),
        );
      },
    );
  }
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        switch (state.status) {
          case SessionStatus.unknown:
            return const Scaffold(body: ProductListShimmer());
          case SessionStatus.authenticated:
            return const ProductListScreen();
          case SessionStatus.unauthenticated:
            return const LoginScreen();
        }
      },
    );
  }
}
