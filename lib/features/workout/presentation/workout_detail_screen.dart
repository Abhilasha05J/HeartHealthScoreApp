import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';

import '../../../core/theme/app_colors.dart';
import 'widgets/workout_dashboard_body.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopBar(title: 'Workout'),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(gradient: AppColors.workoutScreenBackground),
                child: const WorkoutDashboardBody(),
              ),
            ),
          ],
        )

      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: AppColors.darkSurface.withOpacity(0.11),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardTitle.copyWith(color: AppColors.black, fontSize: 18),
                ),
              ),
              // Balances the back button's width so the title stays
              // visually centered instead of skewing right.
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}