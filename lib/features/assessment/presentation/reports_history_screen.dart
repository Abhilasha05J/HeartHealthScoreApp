import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';

/// Full list of report files uploaded across ALL past assessments — not
/// the same thing as `ReportUploadBox`, which only shows the CURRENT
/// draft's reports.
///
/// TODO(backend-integration): no confirmed endpoint exists for this yet.
/// `AssessmentRepository` currently only has `uploadReport`/`deleteReport`
/// for the in-progress draft — nothing that lists reports from previously
/// submitted assessments. Once that endpoint is confirmed (likely
/// something under `/me/encounters` or a dedicated reports-list route),
/// swap the hardcoded empty list below for a real fetch — e.g. a
/// FutureProvider backed by a new `AssessmentRepository.loadReportsHistory()`
/// — and keep this same loading/error/empty/data structure rather than
/// rebuilding the screen.
class ReportsHistoryScreen extends StatelessWidget {
  const ReportsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ASSUMPTION: always empty until the backend contract above exists.
    const reports = <Object>[];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.grey[900],
        titleSpacing: 0,
        title: Text(
          'Reports History',
          style: AppTextStyles.cardTitle.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: reports.isEmpty ? const _EmptyReportsHistory() : const SizedBox.shrink(),
    );
  }
}

class _EmptyReportsHistory extends StatelessWidget {
  const _EmptyReportsHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 40, color: AppColors.inputText.withOpacity(0.35)),
            const SizedBox(height: 12),
            Text(
              'No reports yet',
              style: AppTextStyles.chipLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.inputText.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Reports you upload during an assessment will show up here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.hint.copyWith(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
