import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:heart_health_score/core/router/app_router.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/core/widgets/gradient_text_field.dart';
import 'package:heart_health_score/core/widgets/primary_button.dart';
import 'package:heart_health_score/features/auth/application/auth_providers.dart';

/// REPLACES the old mobile-number + OTP flow entirely — the backend has
/// no OTP endpoint. `/auth/register` takes {name, email, password} and
/// returns a signed-in session directly (confirmed by an actual 201
/// response against the dev server), so there's no separate
/// "verify" step: one form, one submit, done.
///
/// Field-level notes:
/// - Password minimum is 8, matching the backend's own validation
///   error ("String should have at least 8 characters" / min_length: 8)
///   — client-side check mirrors server-side so the user isn't surprised
///   by a 422 after tapping submit.
/// - `name` in the request body is an ASSUMPTION confirmed indirectly:
///   the raw request schema wasn't visible in what was pasted, but a
///   real registration response echoed back `"name": "test"` for
///   whatever was submitted, so the field is accepted. If the backend
///   dev confirms a different field name later, this is the one line
///   (`'name': ...`) in ApiAuthRepository.register to change.
class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = await ref.read(signupControllerProvider.notifier).register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (user != null && mounted) {
      ref.read(currentUserProvider.notifier).state = user;
      //context.push(AppRoutes.profileSetup);
      context.go(AppRoutes.profileSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Full Name', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          GradientTextField(
            controller: _nameController,
            hintText: 'Enter your full name',
            prefixIcon: const Icon(Icons.person_outline, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Enter your full name';
              return null;
            },
          ),
          const SizedBox(height: 20),
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
            hintText: 'At least 8 characters',
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
              if (value == null || value.isEmpty) return 'Create a password';
              if (value.length < 8) return 'Password must be at least 8 characters';
              return null;
            },
          ),
          if (signupState.errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(signupState.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Create Account',
            isLoading: signupState.isSubmitting,
            showArrow: false,
            onPressed: _handleSignup,
          ),
        ],
      ),
    );
  }
}
