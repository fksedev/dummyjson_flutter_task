import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/validators/auth_validators.dart';
import '../../../../../../shared/widgets/primary_button.dart';
import '../../../cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().clearError();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().submit(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final loading = state.status == LoginStatus.loading;
        return Container(
          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 20.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Sign in', style: AppTextStyles.subtitle),
                SizedBox(height: 6.h),
                Text(
                  'Use the DummyJSON demo account to continue.',
                  style: AppTextStyles.caption,
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _usernameController,
                  enabled: !loading,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  style: AppTextStyles.mono(fontSize: 14.sp),
                  validator: AuthValidators.username,
                ),
                SizedBox(height: 14.h),
                TextFormField(
                  controller: _passwordController,
                  enabled: !loading,
                  obscureText: state.obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onSubmit(),
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: loading
                          ? null
                          : () => context
                                .read<LoginCubit>()
                                .togglePasswordVisibility(),
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  style: AppTextStyles.mono(fontSize: 14.sp),
                  validator: AuthValidators.password,
                ),
                if (state.errorMessage != null) ...[
                  SizedBox(height: 14.h),
                  _ErrorBanner(message: state.errorMessage!),
                ],
                SizedBox(height: 22.h),
                PrimaryButton(
                  label: 'Continue',
                  loading: loading,
                  onPressed: loading ? null : _onSubmit,
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.danger, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
