import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/assessment/application/assessment_providers.dart';
import 'package:heart_health_score/features/assessment/domain/assessment_models.dart';

enum _PickSource { camera, gallery, pdf }

/// "No reports yet / Upload Report" box, backed by a real camera/gallery/PDF
/// picker. One instance, shared across all 5 tabs — state lives in
/// AssessmentController so switching tabs doesn't lose uploaded reports.
class ReportUploadBox extends ConsumerWidget {
  const ReportUploadBox({super.key, required this.reports});

  final List<UploadedReport> reports;

  Future<void> _pickAndUpload(BuildContext context, WidgetRef ref, {required _PickSource source}) async {
    final uploading = ref.read(assessmentUploadingProvider.notifier);
    try {
      String? path;
      String? name;
      var type = ReportFileType.image;

      switch (source) {
        case _PickSource.camera:
        case _PickSource.gallery:
          final picker = ImagePicker();
          final file = await picker.pickImage(
            source: source == _PickSource.camera ? ImageSource.camera : ImageSource.gallery,
            imageQuality: 85, // these are photos of reports, not archival scans — fine to compress
          );
          if (file == null) return; // user cancelled
          path = file.path;
          name = file.name;
          break;
        case _PickSource.pdf:
          final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
          final picked = result?.files.single;
          if (picked?.path == null) return; // user cancelled
          path = picked!.path!;
          name = picked.name;
          type = ReportFileType.pdf;
          break;
      }

      uploading.state = true;
      await ref.read(assessmentControllerProvider.notifier).uploadReport(
        localPath: path!,
        fileName: name!,
        type: type,
      );
    } catch (e) {
      // Covers permission denial and picker failures alike — friendly
      // message, not e.toString(), per SKILL.md error-handling rule.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't upload that report. Please try again.")),
        );
      }
    } finally {
      uploading.state = false;
    }
  }

  void _showSourceSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.accentColor),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(context, ref, source: _PickSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.accentColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(context, ref, source: _PickSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.accentColor),
              title: const Text('Choose PDF File'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndUpload(context, ref, source: _PickSource.pdf);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploading = ref.watch(assessmentUploadingProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkSurface, width: 1.4),
      ),
      child: Column(
        children: [
          if (reports.isEmpty)
            Text('No reports yet',
                style: AppTextStyles.chipLabel.copyWith(color: AppColors.inputText.withOpacity(0.6)))
          else
            Column(children: [for (final r in reports) _ReportTile(report: r), const SizedBox(height: 4)]),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: uploading ? null : () => _showSourceSheet(context, ref),
              icon: uploading
                  ? const SizedBox(
                width: 15, height: 15,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
              label: Text(uploading ? 'Uploading…' : (reports.isEmpty ? 'Upload Report' : 'Add Another Report')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: AppTextStyles.chipLabel.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends ConsumerWidget {
  const _ReportTile({required this.report});
  final UploadedReport report;

  Widget _fileIcon() => Container(
    width: 40, height: 40,
    decoration: BoxDecoration(color: AppColors.assessmentFieldBackground, borderRadius: BorderRadius.circular(8)),
    child: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.assessmentGreen, size: 20),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: report.type == ReportFileType.image
                ? Image.file(File(report.localPath), width: 40, height: 40, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fileIcon())
                : _fileIcon(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.fileName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.chipLabel.copyWith(fontSize: 13, color: AppColors.inputText, fontWeight: FontWeight.w600)),
                Text(report.sizeLabel,
                    style: AppTextStyles.chipLabel.copyWith(fontSize: 11, color: AppColors.assessmentMutedText)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: AppColors.assessmentMutedText),
            onPressed: () => ref.read(assessmentControllerProvider.notifier).deleteReport(report.id),
          ),
        ],
      ),
    );
  }
}