import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../application/plan_providers.dart';
import '../data/mock_plan_repository.dart';
import '../domain/plan_data.dart';
import 'widgets/notched_tier_card.dart';
import 'widgets/package_card.dart';
import 'widgets/plan_tier_tab_bar.dart';
import 'widgets/tier_header.dart';

/// The "Plans" branch of the shell's bottom nav. Matches the 3 screenshots:
/// intro line, Basic/Moderate/Advance tabs, then a notched wrapper card
/// holding that tier's header + package cards.
///
/// "View Details" / "Select Plan" both open the package's real booking URL
/// directly (external browser) — there's no in-app detail screen.
class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  Future<void> _openPackageLink(BuildContext context, PackageOption package) async {
    final url = package.link;
    if (url == null || url.trim().isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiersAsync = ref.watch(planTiersProvider);
    final selectedKey = ref.watch(selectedPlanTierProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: tiersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            // Placeholder copy — replace with a mapped, human-readable
            // message once real error codes exist (skill §6.1).
            child: Text('Could not load plans: $error'),
          ),
          data: (tiers) {
            final selectedTier = tiers.firstWhere((t) => t.key == selectedKey);
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/plan.png',
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),

                    const Text(
                      'Plan Benefits',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 24),
                PlanTierTabBar(
                  selected: selectedKey,
                  onSelect: (key) => ref.read(selectedPlanTierProvider.notifier).state = key,
                ),
                const SizedBox(height: 20),
                NotchedTierCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TierHeader(tier: selectedTier),
                      for (final package in selectedTier.packages) ...[
                        PackageCard(
                          package: package,
                          cardBackground: selectedTier.key.cardBackground,
                          onButtonTap: () => _openPackageLink(context, package),
                        ),
                        if (package != selectedTier.packages.last) const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}