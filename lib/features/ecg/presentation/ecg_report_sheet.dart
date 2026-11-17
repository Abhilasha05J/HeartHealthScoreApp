import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_entities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';

void showEcgReportSheet(BuildContext context, EcgReport report) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _EcgReportSheet(report: report),
  );
}

class _EcgReportSheet extends StatelessWidget {
  const _EcgReportSheet({required this.report});

  final EcgReport report;

  Future<void> _openPdf(BuildContext context) async {
    final String? pdfUrl = report.pdfReportUrl;
    if (pdfUrl == null || pdfUrl.isEmpty) return;

    final uri = Uri.tryParse(pdfUrl);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      // Remote URL (used by MockEcgRepository or uploaded backend reports)
       await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (File(pdfUrl).existsSync()) {
      // Local file path returned by physical Spandan Android SDK
       await OpenFilex.open(pdfUrl);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ECG PDF file could not be found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = report.conclusions;
    final m = report.characteristics;
    final String? pdfUrl = report.pdfReportUrl;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '12-Lead ECG Report',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Risk: ${c.risk}',
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Report ID: ${report.reportId}', style: AppTextStyles.hint),
          const SizedBox(height: 20),

          // Conclusions Section
          _SectionBox(
            title: 'Detection',
            body: c.detection,
            highlight: true,
          ),
          const SizedBox(height: 12),
          _SectionBox(
            title: 'Anomalies',
            body: c.anomalies,
          ),
          const SizedBox(height: 12),
          _SectionBox(
            title: 'Recommendation',
            body: c.recommendation,
          ),
          const SizedBox(height: 20),

          // ECG Intervals Grid
          Text(
            'INTERVALS & HEART RATE',
            style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetricChip(label: 'Heart Rate', value: '${m.heartRate} bpm'),
              _MetricChip(label: 'PR', value: '${m.pr} ms'),
              _MetricChip(label: 'QRS', value: '${m.qrs} ms'),
              _MetricChip(label: 'QT', value: '${m.qt} ms'),
              _MetricChip(label: 'QTc', value: '${m.qtc} ms'),
              _MetricChip(label: 'RR', value: '${m.rr} ms'),
            ],
          ),
          const SizedBox(height: 24),

          // PDF Action Button
          if (pdfUrl != null && pdfUrl.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openPdf(context),
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('View Full ECG PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionBox extends StatelessWidget {
  const _SectionBox({
    required this.title,
    required this.body,
    this.highlight = false,
  });

  final String title;
  final String body;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.accentColor.withValues(alpha: 0.08)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.hint.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            body,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: highlight ? 16 : 14,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.hint.copyWith(fontSize: 11.5)),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

class LatestEcgCard extends StatelessWidget {
  const LatestEcgCard({required this.report, required this.onTap});

  final EcgReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.accentColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.monitor_heart_outlined, color: AppColors.accentColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest ECG · ${report.conclusions.detection}',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${report.characteristics.heartRate} bpm · Risk: ${report.conclusions.risk} · Tap for PDF & details',
                    style: AppTextStyles.hint.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.accentColor),
          ],
        ),
      ),
    );
  }
}