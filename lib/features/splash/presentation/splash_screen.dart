import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/application/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _bootstrap();
  }

  /// Minimum splash duration (so the animation/branding is actually seen)
  /// combined with an attempt to restore a previous session. Once the
  /// backend is live, `restoreSession()` will validate/refresh a stored
  /// token; today it always returns null so this simply routes to Auth.
  Future<void> _bootstrap() async {
    final results = await Future.wait([
      ref.read(authRepositoryProvider).restoreSession(),
      Future.delayed(const Duration(milliseconds: 1800)),
    ]);
    if (!mounted) return;

    final user = results[0];
    if (user != null) {
      ref.read(currentUserProvider.notifier).state = user;
      context.go(user.onboardingComplete ? AppRoutes.home : AppRoutes.profileSetup);
    } else {
      context.go(AppRoutes.auth);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.splashGradient()),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(24),
                        child: Image.asset(
                          AppAssets.heartIcon,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.favorite,
                            color: AppColors.accentColor,
                            size: 42,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Heart Health Score', style: AppTextStyles.splashTitle),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'POWERED BY IITI DRISHTI CPS FOUNDATION',
                  style: AppTextStyles.splashFooter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
