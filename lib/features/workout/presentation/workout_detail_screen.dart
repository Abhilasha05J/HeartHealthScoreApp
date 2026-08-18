import 'package:flutter/material.dart';

import '../../../core/theme/fitness_palette.dart';
import 'widgets/workout_dashboard_body.dart';

/// Pushed via `context.push(AppRoutes.workoutDetail)` — same content as the
/// Home tab's [WorkoutDashboardScreen], but with an AppBar + back arrow so
/// it can sit on top of the Home branch's stack (per the skill's
/// push-vs-go navigation rule: this is reachable and should be back-out-able,
/// so it's pushed, not go'd).
class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: FitnessPalette.bgLavenderEnd,
      body: Container(
        decoration: const BoxDecoration(gradient: FitnessPalette.screenBackground),
        child: const WorkoutDashboardBody(),
      ),
    );
  }
}

