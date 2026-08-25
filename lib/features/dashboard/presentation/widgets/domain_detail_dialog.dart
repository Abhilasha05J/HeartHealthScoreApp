import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';

/// Centered modal popup for a single Domain Summary card — shows the same
/// header line as the card plus a Parameter / Value / Severity table.
/// Call [showDomainDetailDialog] rather than constructing this directly.
Future<void> showDomainDetailDialog(BuildContext context, DomainSummaryItem item) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => DomainDetailDialog(item: item),
  );
}

class DomainDetailDialog extends StatelessWidget {
  const DomainDetailDialog({super.key, required this.item});

  final DomainSummaryItem item;

  static const Map<DomainStatus, Color> _statusAccent = {
    DomainStatus.risk: Color(0xFFEF4444),
    DomainStatus.moderate: Color(0xFFFACC15),
    DomainStatus.normal: Color(0xFF32D74B),
  };

  static const Map<DomainStatus, Color> _statusBadgeBg = {
    DomainStatus.risk: AppColors.riskChipBackground,
    DomainStatus.moderate: AppColors.moderateChipBackground,
    DomainStatus.normal: AppColors.normalChipBackground,
  };

  static const Map<DomainStatus, String> _statusLabel = {
    DomainStatus.risk: 'HIGH',
    DomainStatus.moderate: 'MODERATE',
    DomainStatus.normal: 'NORMAL',
  };

  @override
  Widget build(BuildContext context) {
    final accent = _statusAccent[item.status]!;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Text(
                      item.title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusBadgeBg[item.status],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel[item.status]!,
                      style: AppTextStyles.chipLabel.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '${item.parameterCount} parameter${item.parameterCount == 1 ? '' : 's'} '
                  '\u2022 HHS severity ${item.hhsSeverity.toStringAsFixed(2)} '
                  '\u2022 weight ${item.weight}',
                  style: AppTextStyles.hint.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(height: 18),
              const _TableHeader(),
              const Divider(height: 20),
              Flexible(
                child: item.parameters.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No parameter-level detail available for this domain yet.',
                          style: AppTextStyles.hint,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: item.parameters.length,
                        separatorBuilder: (_, __) => const Divider(height: 18),
                        itemBuilder: (context, i) => _ParameterRow(detail: item.parameters[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.hint.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600);
    return Row(
      children: [
        Expanded(flex: 4, child: Text('PARAMETER', style: style)),
        Expanded(flex: 3, child: Text('VALUE', style: style)),
        Expanded(flex: 3, child: Text('SEVERITY', style: style, textAlign: TextAlign.right)),
      ],
    );
  }
}

class _ParameterRow extends StatelessWidget {
  const _ParameterRow({required this.detail});

  final DomainParameterDetail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            detail.label,
            style: AppTextStyles.chipLabel.copyWith(fontSize: 13.5),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            detail.valueLabel,
            style: AppTextStyles.chipLabel.copyWith(fontSize: 13.5, color: AppColors.headingColor),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: _SeverityBadge(severity: detail.severity),
          ),
        ),
      ],
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final ParameterSeverity severity;

  static const Map<ParameterSeverity, Color> _accent = {
    ParameterSeverity.atRisk: Color(0xFFEF4444),
    ParameterSeverity.borderline: Color(0xFFFACC15),
    ParameterSeverity.normal: Color(0xFF32D74B),
    ParameterSeverity.missing: Color(0xFF9CA3AF),
    ParameterSeverity.notApplicable: Color(0xFF9CA3AF),
  };

  static const Map<ParameterSeverity, String> _label = {
    ParameterSeverity.atRisk: 'High',
    ParameterSeverity.borderline: 'Moderate',
    ParameterSeverity.normal: 'Normal',
    ParameterSeverity.missing: 'Missing',
    ParameterSeverity.notApplicable: 'N/A',
  };

  @override
  Widget build(BuildContext context) {
    final color = _accent[severity]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(
            _label[severity]!,
            style: AppTextStyles.chipLabel.copyWith(fontSize: 11.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
