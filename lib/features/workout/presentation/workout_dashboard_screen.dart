import 'package:flutter/material.dart';

import '../../../core/theme/fitness_palette.dart';
import 'widgets/workout_dashboard_body.dart';

/// The "Home" branch content inside [HomeShell] — matches the mockup with
/// no AppBar (the day picker sits directly under the status bar). The
/// standalone "Workout" screen (with AppBar + back button, reached e.g. via
/// a "See all" tap) reuses the same [WorkoutDashboardBody] — see
/// `workout_detail_screen.dart`.
class WorkoutDashboardScreen extends StatelessWidget {
  const WorkoutDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
     // decoration: const BoxDecoration(gradient: FitnessPalette.screenBackground),
      child: const SafeArea(
        bottom: false,
        child: WorkoutDashboardBody(),
      ),
    );
  }
}
