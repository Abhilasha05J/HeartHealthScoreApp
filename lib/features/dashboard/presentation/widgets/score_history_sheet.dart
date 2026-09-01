import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';

/// Opens the Score History bottom sheet — a trend chart plus a
/// latest-first list of every entry in [DashboardData.scoreHistory].
/// Called from the history icon on [HealthScoreCard].
Future<void> showScoreHistorySheet(BuildContext context, DashboardData data) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ScoreHistorySheet(entries: data.scoreHistory),
  );
}

class ScoreHistorySheet extends StatelessWidget {
  const ScoreHistorySheet({super.key, required this.entries});

  final List<ScoreHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    // Chronological (oldest → newest) for the chart; reversed for the list
    // below so the most recent entry is at the top.
    final chronological = [...entries]..sort((a, b) => a.date.compareTo(b.date));
    final latestFirst = chronological.reversed.toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Score History', style: AppTextStyles.pageHeading.copyWith(fontSize: 18)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              if (chronological.isEmpty)
                const Expanded(child: _EmptyHistoryState())
              else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: SizedBox(
                    height: 180,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _TrendPainter(entries: chronological),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: latestFirst.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _HistoryRow(entry: latestFirst[index]),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No score history yet.', style: AppTextStyles.hint),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final ScoreHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.isSelfLogged
                  ? AppColors.inputText.withOpacity(0.3)
                  : AppColors.accentColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(entry.date), style: AppTextStyles.chipLabel.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  entry.isSelfLogged ? 'Self-logged' : 'Visit',
                  style: AppTextStyles.hint.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          Text(
            entry.hhs.toStringAsFixed(1),
            style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
          ),
        ],
      ),
    );
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) => '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

/// Simple time-scaled line chart of `hhs` over `date`. Deliberately doesn't
/// pull in a charting package — follows the same hand-rolled CustomPainter
/// approach already used for the score gauge on [HealthScoreCard].
class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.entries});

  final List<ScoreHistoryEntry> entries;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.length < 2) {
      if (entries.length == 1) _drawSinglePoint(canvas, size);
      return;
    }

    const topPad = 12.0;
    const bottomPad = 20.0;
    final minDate = entries.first.date;
    final maxDate = entries.last.date;
    final totalSpan = maxDate.difference(minDate).inMilliseconds;

    final minHhs = entries.map((e) => e.hhs).reduce((a, b) => a < b ? a : b);
    final maxHhs = entries.map((e) => e.hhs).reduce((a, b) => a > b ? a : b);
    // Pad the range a little so the line doesn't touch the top/bottom edges.
    final rangeLow = (minHhs - 5).clamp(0, 100).toDouble();
    final rangeHigh = (maxHhs + 5).clamp(0, 100).toDouble();
    final range = (rangeHigh - rangeLow) == 0 ? 1 : (rangeHigh - rangeLow);

    Offset pointFor(ScoreHistoryEntry e) {
      final xT = totalSpan == 0 ? 0.0 : e.date.difference(minDate).inMilliseconds / totalSpan;
      final yT = (e.hhs - rangeLow) / range;
      return Offset(
        xT * size.width,
        topPad + (1 - yT) * (size.height - topPad - bottomPad),
      );
    }

    final points = entries.map(pointFor).toList();

    final linePaint = Paint()
      ..color = AppColors.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.accentColor;
    final selfDotPaint = Paint()..color = AppColors.accentColor.withOpacity(0.35);
    for (var i = 0; i < points.length; i++) {
      final isLast = i == points.length - 1;
      canvas.drawCircle(
        points[i],
        isLast ? 4.5 : 2.5,
        entries[i].isSelfLogged && !isLast ? selfDotPaint : dotPaint,
      );
    }

    _drawLabel(canvas, points.first, entries.first.hhs, alignRight: false);
    _drawLabel(canvas, points.last, entries.last.hhs, alignRight: true);
  }

  void _drawSinglePoint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 4.5, Paint()..color = AppColors.accentColor);
  }

  void _drawLabel(Canvas canvas, Offset point, double value, {required bool alignRight}) {
    final tp = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(1),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inputText),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final dx = alignRight ? point.dx - tp.width : point.dx;
    final dy = point.dy - tp.height - 6;
    tp.paint(canvas, Offset(dx.clamp(0, double.infinity), dy < 0 ? point.dy + 8 : dy));
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => oldDelegate.entries != entries;
}