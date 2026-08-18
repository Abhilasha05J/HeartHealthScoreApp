import 'package:flutter/material.dart';

import '../../../../core/theme/fitness_palette.dart';

/// Soft blue gradient header with "Your Profile" title and the
/// name/email/avatar card, matching the mockup.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.initial, required this.fullName, required this.email});

  final String initial;
  final String fullName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: const BoxDecoration(
        gradient: FitnessPalette.profileHeaderGradient,
       // borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Profile', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: FitnessPalette.textPrimary)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FitnessPalette.cardBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: FitnessPalette.profileAvatarBg,
                  child: Text(
                    initial,
                    style: const TextStyle(color: FitnessPalette.profileAvatarFg, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: FitnessPalette.textPrimary)),
                      const SizedBox(height: 2),
                      Text(email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: FitnessPalette.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
