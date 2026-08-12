import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/dashboard_data.dart';
import 'domain_filter_tab.dart';
/// "Domain Summary" — a status filter row (All / Risk / Moderate / Normal)
/// followed by one status card per health domain. Filtering reuses the
/// same [DomainFilterTabs] widget and [filterByDomainStatus] helper as
/// Burden Breakdown.
class DomainSummarySection extends StatefulWidget {
  const DomainSummarySection({super.key, required this.items});

  final List<DomainSummaryItem> items;

  @override
  State<DomainSummarySection> createState() => _DomainSummarySectionState();
}

class _DomainSummarySectionState extends State<DomainSummarySection> {
  DomainFilter _filter = DomainFilter.all;

  List<DomainSummaryItem> get _filteredItems =>
      filterByDomainStatus(widget.items, _filter, (i) => i.status);

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DomainFilterTabs(
          selected: _filter,
          onChanged: (f) => setState(() => _filter = f),
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          _DomainSummaryCard(item: item),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _DomainSummaryCard extends StatelessWidget {
  const _DomainSummaryCard({required this.item});

  final DomainSummaryItem item;

  // Solid accent color per status — left border, dot, and badge text.
  static const Map<DomainStatus, Color> _accent = {
    DomainStatus.risk: Color(0xFFEF4444),
    DomainStatus.moderate: Color(0xFFFACC15),
    DomainStatus.normal: Color(0xFF32D74B),
  };

  // 20%-opacity tint per status — badge background.
  static const Map<DomainStatus, Color> _badgeBg = {
    DomainStatus.risk: AppColors.riskChipBackground,
    DomainStatus.moderate: AppColors.moderateChipBackground,
    DomainStatus.normal: AppColors.normalChipBackground,
  };

  // Badge copy is intentionally not the same word as the filter tab —
  // "Risk" filters the tab, but the badge itself reads "HIGH" per the
  // mockup. Adjust here if your source data has a distinct badge label.
  static const Map<DomainStatus, String> _badgeLabel = {
    DomainStatus.risk: 'HIGH',
    DomainStatus.moderate: 'MODERATE',
    DomainStatus.normal: 'NORMAL',
  };

  @override
  Widget build(BuildContext context) {
    final accent = _accent[item.status]!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: accent, width: 4)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5, right: 6),
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyles.chipLabel.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeBg[item.status],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _badgeLabel[item.status]!,
                  style: AppTextStyles.chipLabel.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '${item.parameterCount} parameter${item.parameterCount == 1 ? '' : 's'} '
              '\u2022 HHS severity ${item.hhsSeverity.toStringAsFixed(2)} '
              '\u2022 weight ${item.weight}',
              style: AppTextStyles.hint.copyWith(fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                _StatDot(color: _accent[DomainStatus.normal]!, label: '${item.normalCount} normal'),
                const SizedBox(width: 14),
                _StatDot(color: _accent[DomainStatus.moderate]!, label: '${item.borderlineCount} borderline'),
                const SizedBox(width: 14),
                _StatDot(color: _accent[DomainStatus.risk]!, label: '${item.atRiskCount} at risk'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDot extends StatelessWidget {
  const _StatDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.hint.copyWith(fontSize: 11.5)),
      ],
    );
  }
}
