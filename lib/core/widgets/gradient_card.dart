import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';

/// The pink-to-grey gradient card container used behind every form
/// section in the app (Auth card, Profile Setup, Daily Activity,
/// Basic Vitals).
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 28,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
