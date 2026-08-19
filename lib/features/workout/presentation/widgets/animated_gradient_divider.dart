import 'package:flutter/material.dart';

class GradientDivider extends StatelessWidget {
  const GradientDivider({
    super.key,
    required this.color,
    this.height = 1,
  });

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color.withOpacity(0.0),
            color.withOpacity(0.35),
            color.withOpacity(0.75),
            color,
            color.withOpacity(0.75),
            color.withOpacity(0.35),
            color.withOpacity(0.0),
          ],
          stops: const [
            0.0,
            0.20,
            0.38,
            0.50,
            0.62,
            0.80,
            1.0,
          ],
        ),
      ),
    );
  }
}