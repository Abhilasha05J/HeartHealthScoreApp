import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../application/auth_providers.dart';

/// Mobile Number + OTP sign-up flow, matching the Sign Up tab mock:
/// step 1 -> enter mobile number, tap Send OTP
/// step 2 (otpSent) -> OTP field is enabled, button becomes "Verify & Continue"
class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your mobile number';
    if (value.trim().length != 10) return 'Enter a valid 10-digit number';
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter the OTP';
    if (value.trim().length != 6) return 'OTP must be 6 digits';
    return null;
  }

  Future<void> _handlePrimaryAction() async {
    final otpState = ref.read(otpSignupControllerProvider);
    final controller = ref.read(otpSignupControllerProvider.notifier);

    if (!otpState.otpSent) {
      if (_validatePhone(_phoneController.text) != null) {
        setState(() {}); // trigger form validation display
        _formKey.currentState?.validate();
        return;
      }
      await controller.sendOtp('+91${_phoneController.text.trim()}');
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = await controller.verifyOtp(
      '+91${_phoneController.text.trim()}',
      _otpController.text.trim(),
    );
    if (user != null && mounted) {
      ref.read(currentUserProvider.notifier).state = user;
      context.push(AppRoutes.profileSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpSignupControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Mobile Number', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 0)),
          const SizedBox(height: 10),
          GradientTextField(
            controller: _phoneController,
            hintText: '+91  ',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/icons/mobile.png',
                width: 10,
                height: 10,
              ),
            ),
            keyboardType: TextInputType.phone,
            readOnly: otpState.otpSent,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: _validatePhone,
          ),
          const SizedBox(height: 20),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: otpState.otpSent
                  ? Column(
                      key: const ValueKey('otp-field'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Enter OTP', style: AppTextStyles.sectionLabel.copyWith(letterSpacing: 0)),
                        const SizedBox(height: 10),
                        GradientTextField(
                          controller: _otpController,
                          hintText: '••••••',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          autofocus: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: _validateOtp,
                        ),
                      ],
                    )
                  : const SizedBox(key: ValueKey('otp-field-empty'), width: double.infinity),
            ),
          ),
          if (otpState.errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(otpState.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 28),
          PrimaryButton(
            label: otpState.otpSent ? 'Verify & Continue' : 'Send OTP',
            isLoading: otpState.isSubmitting,
            showArrow: false,
            onPressed: _handlePrimaryAction,
          ),
          if (otpState.otpSent) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: otpState.isSubmitting
                    ? null
                    : () => ref.read(otpSignupControllerProvider.notifier).sendOtp(
                          '+91${_phoneController.text.trim()}',
                        ),
                child: Text('Resend OTP', style: AppTextStyles.linkText),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
