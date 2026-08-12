import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';

/// Filter for domain lists — shared by Domain Summary and Burden Breakdown,
/// which both filter the same set of domains by their [DomainStatus].
enum DomainFilter { all, risk, moderate, normal }

/// The "All / Risk / Moderate / Normal" pill row. Solid black/white for
/// "All"; Risk/Moderate/Normal use a 20%-opacity tint background with the
/// matching solid color as text + border when selected.
class DomainFilterTabs extends StatelessWidget {
  const DomainFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final DomainFilter selected;
  final ValueChanged<DomainFilter> onChanged;

  static const _labels = {
    DomainFilter.all: 'All',
    DomainFilter.risk: 'Risk',
    DomainFilter.moderate: 'Moderate',
    DomainFilter.normal: 'Normal',
  };

  static const Map<DomainFilter, Color> _selectedBg = {
    DomainFilter.all: AppColors.allChipBackground,
    DomainFilter.risk: AppColors.riskChipBackground,
    DomainFilter.moderate: AppColors.moderateChipBackground,
    DomainFilter.normal: AppColors.normalChipBackground,
  };

  static const Map<DomainFilter, Color> _selectedText = {
    DomainFilter.all: Color(0xFF5C85D9),
    DomainFilter.risk: Color(0xFFEF4444),
    DomainFilter.moderate: Color(0xFFFACC15),
    DomainFilter.normal: Color(0xFF32D74B),
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: DomainFilter.values.map((f) {
        final isSelected = f == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _selectedBg[f] : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: _selectedText[f]!, width: 1)
                    : null,
              ),
              child: Text(
                _labels[f]!,
                style: AppTextStyles.chipLabel.copyWith(
                  fontSize: 13,
                  color: isSelected ? _selectedText[f] : AppColors.headingColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Shared helper: filter a list of domain-bearing items down to the
/// selected [DomainFilter]. Works for anything exposing a [DomainStatus].
List<T> filterByDomainStatus<T>(
    List<T> items,
    DomainFilter filter,
    DomainStatus Function(T) statusOf,
    ) {
  switch (filter) {
    case DomainFilter.all:
      return items;
    case DomainFilter.risk:
      return items.where((i) => statusOf(i) == DomainStatus.risk).toList();
    case DomainFilter.moderate:
      return items.where((i) => statusOf(i) == DomainStatus.moderate).toList();
    case DomainFilter.normal:
      return items.where((i) => statusOf(i) == DomainStatus.normal).toList();
  }
}