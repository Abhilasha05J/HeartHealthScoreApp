import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/plan_data.dart';


class PlanTierTabBar extends StatelessWidget {
  const PlanTierTabBar({super.key, required this.selected, required this.onSelect});

  final PlanTierKey selected;
  final ValueChanged<PlanTierKey> onSelect;

  static const _tabs = [
    (key: PlanTierKey.basic, label: 'Basic'),
    (key: PlanTierKey.moderate, label: 'Moderate'),
    (key: PlanTierKey.advance, label: 'Advance'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final tab in _tabs) _TabItem(label: tab.label, active: tab.key == selected, onTap: () => onSelect(tab.key)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: active ? 22 : 19,
              fontWeight: active ? FontWeight.w800 : FontWeight.w400,
              color: active ? AppColors.accentColor : AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: active ? 56 : 0,
            color: AppColors.accentColor,
          ),
        ],
      ),
    );
  }
}
