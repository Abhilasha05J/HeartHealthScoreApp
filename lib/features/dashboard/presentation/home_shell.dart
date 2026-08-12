
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'widgets/expandable_log_fab.dart';

/// Persistent shell: bottom nav bar + expandable "+" FAB stay visible
/// across every screen nested under this shell (Home dashboard, Water
/// Intake, Reminder, Plans, Setting), via go_router's
/// StatefulShellRoute.indexedStack (wired up in app_router.dart).
///
/// Each branch keeps its own independent navigation stack — [navigationShell]
/// is what makes that possible: [navigationShell.currentIndex] tracks
/// which branch is active, and [navigationShell.goBranch] switches
/// between them (preserving each branch's stack/scroll position instead
/// of rebuilding it, similar to what the old IndexedStack-based version
/// did manually with a Riverpod provider — that provider is gone now
/// since go_router owns this state directly).
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: const ExpandableLogFab(),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tapping the already-active tab pops back to that branch's
          // initial route instead of doing nothing — standard bottom-nav
          // behavior (e.g. tapping "Home" while deep in Water Intake
          // takes you back to the dashboard).
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              label: 'Home',
              path: 'assets/icons/home.png',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              label: 'Reminder',
              path: 'assets/icons/reminder.png',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            // NOTE: preserved exactly as you had it — this button also
            // targets the Reminder branch (index 1), not a dedicated
            // Profile screen. Still flagging this in case it's a
            // copy-paste leftover rather than intentional; happy to add
            // a real Profile branch instead once confirmed.
            _NavItem(
              label: 'Profile',
              path: 'assets/icons/profile.png',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              label: 'Plans',
              path: 'assets/icons/plans.png',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              label: 'Setting',
              path: 'assets/icons/settings.png',
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.path,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String path;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentColor : AppColors.inputText.withOpacity(0.45);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              path,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.chipLabel.copyWith(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}