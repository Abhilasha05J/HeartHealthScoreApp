import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_health_score/core/router/app_router.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/application/dashboard_providers.dart';

class ExpandableLogFab extends ConsumerWidget {
  const ExpandableLogFab({super.key});

  static const _actions = [
    _FabActionSpec(label: 'Log Workout', assetPath: 'assets/icons/logworkout.png'),
    _FabActionSpec(
      label: 'Log Water',
      assetPath: 'assets/icons/logwater.png',
      route: AppRoutes.waterIntake,
    ),
    _FabActionSpec(label: 'Log Meal', assetPath: 'assets/icons/logmeal.png'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(fabExpandedProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final action in _actions.reversed)
          _FabActionRow(
            spec: action,
            expanded: expanded,
            onTap: () {
              ref.read(fabExpandedProvider.notifier).state = false;
              if (action.route != null) {
                context.push(action.route!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${action.label} — coming soon')),
                );
              }
            },
          ),
        FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: AppColors.accentColor,
          onPressed: () => ref.read(fabExpandedProvider.notifier).state = !expanded,
          child: AnimatedRotation(
            turns: expanded ? 0.125 : 0, // 45° -> "+" reads as "×"
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

class _FabActionSpec {
  const _FabActionSpec({required this.label, required this.assetPath, this.route});
  final String label;
  final String assetPath;
  final String? route;
}

class _FabActionRow extends StatelessWidget {
  const _FabActionRow({
    required this.spec,
    required this.expanded,
    required this.onTap,
  });

  final _FabActionSpec spec;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !expanded,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: expanded ? Offset.zero : const Offset(0, 0.3),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: expanded ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      spec.label,
                      style: AppTextStyles.chipLabel.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset(
                    spec.assetPath,
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_circle_outline, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}