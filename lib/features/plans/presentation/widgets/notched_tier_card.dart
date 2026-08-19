import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

Path _notchedCardPath(
    Size size, {
      required double radius,
      required double notchWidth,
      required double notchDrop,
    }) {
  final w = size.width;
  final h = size.height;

  final r = radius;

  // The point where the special top-right transition begins.
  final curveStartX = w - notchWidth;

  return Path()
  // ─────────────────────────────────────────
  // TOP-LEFT CORNER
  // ─────────────────────────────────────────
    ..moveTo(r, 0)
    ..lineTo(curveStartX - 20, 0)

  // ─────────────────────────────────────────
  // FIRST CURVE
  //
  // Smoothly takes the top horizontal edge
  // downward toward the stepped section.
  // ─────────────────────────────────────────
    ..cubicTo(
      curveStartX - 5,
      0,
      curveStartX,
      10,
      curveStartX + 4,
      28,
    )

  // ─────────────────────────────────────────
  // SECOND CURVE
  //
  // Continues the rounded transition until
  // it becomes the lower horizontal edge.
  // ─────────────────────────────────────────
    ..cubicTo(
      curveStartX + 8,
      48,
      curveStartX + 12,
      notchDrop,
      curveStartX + 48,
      notchDrop,
    )

  // ─────────────────────────────────────────
  // LOWER HORIZONTAL STEP
  // ─────────────────────────────────────────
    ..lineTo(w - r, notchDrop)

  // ─────────────────────────────────────────
  // CURVE INTO RIGHT EDGE
  // ─────────────────────────────────────────
    ..cubicTo(
      w - 8,
      notchDrop,
      w,
      notchDrop + 8,
      w,
      notchDrop + r,
    )

  // ─────────────────────────────────────────
  // RIGHT EDGE
  // ─────────────────────────────────────────
    ..lineTo(w, h - r)

  // ─────────────────────────────────────────
  // BOTTOM-RIGHT CORNER
  // ─────────────────────────────────────────
    ..arcToPoint(
      Offset(w - r, h),
      radius: Radius.circular(r),
    )

  // ─────────────────────────────────────────
  // BOTTOM EDGE
  // ─────────────────────────────────────────
    ..lineTo(r, h)

  // ─────────────────────────────────────────
  // BOTTOM-LEFT CORNER
  // ─────────────────────────────────────────
    ..arcToPoint(
      Offset(0, h - r),
      radius: Radius.circular(r),
    )

  // ─────────────────────────────────────────
  // LEFT EDGE
  // ─────────────────────────────────────────
    ..lineTo(0, r)

  // ─────────────────────────────────────────
  // TOP-LEFT CORNER
  // ─────────────────────────────────────────
    ..arcToPoint(
      Offset(r, 0),
      radius: Radius.circular(r),
    )

    ..close();
}

/// Clips the child to the custom tier-card shape.
class _NotchedCardClipper extends CustomClipper<Path> {
  const _NotchedCardClipper({
    this.radius = 28,
    this.notchWidth = 115,
    this.notchDrop = 80,
  });

  final double radius;
  final double notchWidth;
  final double notchDrop;

  @override
  Path getClip(Size size) {
    return _notchedCardPath(
      size,
      radius: radius,
      notchWidth: notchWidth,
      notchDrop: notchDrop,
    );
  }

  @override
  bool shouldReclip(covariant _NotchedCardClipper oldClipper) {
    return oldClipper.radius != radius ||
        oldClipper.notchWidth != notchWidth ||
        oldClipper.notchDrop != notchDrop;
  }
}

/// Paints the outer tier card.
///
/// The shadow is intentionally very subtle because the reference design
/// primarily uses a light gray outline rather than a strong drop shadow.
class _NotchedCardPainter extends CustomPainter {
  const _NotchedCardPainter({
    required this.radius,
    required this.notchWidth,
    required this.notchDrop,
    required this.fillColor,
    required this.borderColor,
  });

  final double radius;
  final double notchWidth;
  final double notchDrop;
  final Color fillColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _notchedCardPath(
      size,
      radius: radius,
      notchWidth: notchWidth,
      notchDrop: notchDrop,
    );

    // Very subtle shadow.
    canvas.drawShadow(
      path,
      Colors.black.withOpacity(0.06),
      2,
      false,
    );

    // Card fill.
    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    // Thin light-gray border.
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _NotchedCardPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.notchWidth != notchWidth ||
        oldDelegate.notchDrop != notchDrop ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor;
  }
}

/// Outer tier card used to contain the tier header and package cards.
///
/// The top-right corner has the custom curved stepped design from the
/// reference UI.
class NotchedTierCard extends StatelessWidget {
  const NotchedTierCard({
    super.key,
    required this.child,
  });

  final Widget child;

  // Normal rounded corners.
  static const double _radius = 28;

  // Width of the special curved top-right section.
  static const double _notchWidth = 80;

  // Vertical depth of the stepped section.
  static const double _notchDrop = 50;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _NotchedCardPainter(
        radius: _radius,
        notchWidth: _notchWidth,
        notchDrop: _notchDrop,
        fillColor: AppColors.planOuterCardBg,
        borderColor: AppColors.planOuterCardBorder,
      ),
      child: ClipPath(
        clipper: const _NotchedCardClipper(
          radius: _radius,
          notchWidth: _notchWidth,
          notchDrop: _notchDrop,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            32,
          ),
          child: child,
        ),
      ),
    );
  }
}