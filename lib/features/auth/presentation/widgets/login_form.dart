import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../application/auth_providers.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = await ref.read(loginControllerProvider.notifier).loginWithPassword(
          _identifierController.text.trim(),
          _passwordController.text,
        );
    if (user != null && mounted) {
      ref.read(currentUserProvider.notifier).state = user;
      context.push(AppRoutes.profileSetup);
    }
  }

  Future<void> _handleGoogleLogin() async {
    final user = await ref.read(loginControllerProvider.notifier).loginWithGoogle();
    if (user != null && mounted) {
      ref.read(currentUserProvider.notifier).state = user;
      context.push(AppRoutes.profileSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Email or Mobile Number', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          GradientTextField(
            controller: _identifierController,
            hintText: 'Enter',
            prefixIcon: const Icon(Icons.mail_outline, size: 20),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Enter your email or mobile number';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text('Password', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          GradientTextField(
            controller: _passwordController,
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your password';
              if (value.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO(backend-integration): wire up forgot-password flow
                // once the endpoint is available.
              },
              child: Text('Forgot password?', style: AppTextStyles.linkText),
            ),
          ),
          if (loginState.errorMessage != null) ...[
            const SizedBox(height: 4),
            Text(loginState.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Login',
            showArrow: false,
            isLoading: loginState.isSubmitting,
            onPressed: _handleLogin,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.divider)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('or', style: AppTextStyles.hint),
              ),
              const Expanded(child: Divider(color: AppColors.divider)),
            ],
          ),
          const SizedBox(height: 24),
          SecondaryOutlinedButton(
            label: 'Continue with Google',
            onPressed: loginState.isSubmitting ? null : _handleGoogleLogin,
            leading: Image.asset(
              AppAssets.google,
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
