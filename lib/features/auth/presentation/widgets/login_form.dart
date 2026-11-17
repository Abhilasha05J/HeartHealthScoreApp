import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:heart_health_score/core/router/app_router.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/core/widgets/gradient_text_field.dart';
import 'package:heart_health_score/core/widgets/primary_button.dart';
import 'package:heart_health_score/features/auth/application/auth_providers.dart';

/// CHANGED from mock era:
/// - Field is "Email" only, not "Email or Mobile Number" — /auth/login
///   only accepts {email, password}, confirmed against the live schema.
/// - Password min length is 8, matching the backend's own validation
///   (register: "Invalid email or password shorter than 8 characters"),
///   so the client won't accept input the server would reject anyway.
/// - "Continue with Google" removed — no OAuth endpoint exists on the
///   backend. Re-add if/when one ships.
/// - "Forgot password?" no longer a silent no-op TODO — there is no
///   self-service reset endpoint (password reset is admin-only, per
///   Swagger: POST /auth/users/{user_id}/password). Shows an
///   informational dialog instead. ASSUMPTION (flagged): swap this copy
///   for whatever real support contact flow you want once decided.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = await ref.read(loginControllerProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (user != null && mounted) {
      ref.read(currentUserProvider.notifier).state = user;
     // context.push(AppRoutes.profileSetup);
      context.go(user.onboardingComplete ? AppRoutes.home : AppRoutes.profileSetup);
    }
  }

  void _showForgotPasswordInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password reset'),
        content: const Text(
          'Self-service password reset isn\'t available yet. '
              'Please contact your care team to have your password reset.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Email', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          GradientTextField(
            controller: _emailController,
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.mail_outline, size: 20),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) return 'Enter your email';
              if (!_emailRegex.hasMatch(trimmed)) return 'Enter a valid email address';
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
              if (value.length < 8) return 'Password must be at least 8 characters';
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordInfo,
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
        ],
      ),
    );
  }
}
