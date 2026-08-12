import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/core/constants/app_assets.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/core/widgets/gradient_card.dart';
import 'package:heart_health_score/features/auth/application/auth_providers.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_form.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(authTabProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 105,
                  height: 105,
                  padding: const EdgeInsets.all(22),
                  child: Image.asset(
                    AppAssets.heartIcon,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.favorite, color: AppColors.accentColor, size: 38),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Heart Health Score', textAlign: TextAlign.center, style: AppTextStyles.appTitle),
              const SizedBox(height: 6),
              Text(
                'Your premium health companion',
                textAlign: TextAlign.center,
                style: AppTextStyles.appTagline,
              ),
              const SizedBox(height: 32),
              GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AuthTabToggle(
                      activeTab: activeTab,
                      onChanged: (tab) => ref.read(authTabProvider.notifier).state = tab,
                    ),
                    const SizedBox(height: 28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: activeTab == AuthTab.login
                          ? const LoginForm(key: ValueKey('login'))
                          : const SignupForm(key: ValueKey('signup')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthTabToggle extends StatelessWidget {
  const _AuthTabToggle({required this.activeTab, required this.onChanged});

  final AuthTab activeTab;
  final ValueChanged<AuthTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _TabButton(
          label: 'Login',
          selected: activeTab == AuthTab.login,
          onTap: () => onChanged(AuthTab.login),
        )),
        const SizedBox(width: 12),
        Expanded(child: _TabButton(
          label: 'Sign Up',
          selected: activeTab == AuthTab.signup,
          onTap: () => onChanged(AuthTab.signup),
        )),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.accentColor.withOpacity(0.5) : Colors.transparent,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: AppTextStyles.tabLabel.copyWith(
            color: selected ? AppColors.accentColor : AppColors.accentColor.withOpacity(0.45),
          ),
        ),
      ),
    );
  }
}
