import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/dashboard_data.dart';
import 'domain_filter_tab.dart';

/// Horizontal bar chart for "Burden Breakdown" — a status filter row
/// (All / Risk / Moderate / Normal), fixed 0..1 gridlines behind the bars,
/// and one labeled row per domain. Built with plain Rows/Containers rather
/// than a charting package: it's a simple fixed-axis horizontal bar list,
/// not worth the extra dependency.
class BurdenBreakdownChart extends StatefulWidget {
  const BurdenBreakdownChart({super.key, required this.items});

  final List<BurdenItem> items;

  @override
  State<BurdenBreakdownChart> createState() => _BurdenBreakdownChartState();
}

class _BurdenBreakdownChartState extends State<BurdenBreakdownChart> {
  DomainFilter _filter = DomainFilter.all;

  static const double _axisMax = 1.0;
  static const List<double> _gridlines = [0, 0.25, 0.5, 0.75, 1.0];

  List<BurdenItem> get _filteredItems =>
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
        const SizedBox(height: 18),
        _GridBackground(
          rowCount: items.length,
          gridlineCount: _gridlines.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in items) ...[
                _BurdenRow(item: item, axisMax: _axisMax),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          // Aligns the axis labels under the bar area (which starts after
          // the fixed-width label column) — keep in sync with _BurdenRow's
          // label column width and _GridBackground's left padding.
          padding: const EdgeInsets.only(left: 96),
          child: Row(
            children: _gridlines
                .map((g) => Expanded(
              child: Text(
                g == g.roundToDouble() ? g.toInt().toString() : g.toString(),
                style: AppTextStyles.hint.copyWith(fontSize: 11),
                textAlign: g == 0 ? TextAlign.left : TextAlign.right,
              ),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// Draws vertical gridlines behind [child] at each of [gridlineCount]
/// evenly-spaced fractions (0, 0.25, 0.5, 0.75, 1), spanning the height of
/// [rowCount] bar rows.
class _GridBackground extends StatelessWidget {
  const _GridBackground({
    required this.rowCount,
    required this.gridlineCount,
    required this.child,
  });

  final int rowCount;
  final int gridlineCount;
  final Widget child;

  // Keep in sync with _BurdenRow's bar height (14) and the SizedBox(height:
  // 14) spacer used between rows above.
  static const double _rowHeight = 14;
  static const double _rowSpacing = 14;

  @override
  Widget build(BuildContext context) {
    if (rowCount == 0) return child;
    final height = rowCount * (_rowHeight + _rowSpacing);

    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(left: 96),
            child: SizedBox(
              height: height,
              child: Row(
                children: List.generate(gridlineCount - 1, (i) {
                  final isLast = i == gridlineCount - 2;
                  return Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: AppColors.chartGridLine, width: 1),
                          right: isLast
                              ? BorderSide(color: AppColors.chartGridLine, width: 1)
                              : BorderSide.none,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _BurdenRow extends StatelessWidget {
  const _BurdenRow({required this.item, required this.axisMax});

  final BurdenItem item;
  final double axisMax;

  @override
  Widget build(BuildContext context) {
    final barColor = item.highlighted ? AppColors.burdenBarRed : AppColors.burdenBarYellow;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            item.label,
            style: AppTextStyles.chipLabel.copyWith(fontSize: 12.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fraction = (item.value / axisMax).clamp(0.0, 1.0);
              return Stack(
                children: [
                  Container(height: 14, color: Colors.transparent),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}