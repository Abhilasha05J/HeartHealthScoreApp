import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  static const Color splashGradientStart = Color(0x80DDE6F4); // accentBlue @ ~10%
  static const Color splashGradientEnd = Color(0xFFFFFFFF);

  static const Color cardGradientStart = Color(0x265C85D9); // #5C85D9 @ 15% (top)
  static const Color cardGradientEnd = Color(0xFFF2F7F1); // (bottom)

  static const Color fieldGradientStart = Color(0xAA334D35); // used at 67% opacity
  static const double fieldGradientStartOpacity = 0.25;
  static const Color fieldGradientMid = Color(0xFFD8DFE3);
  static const double fieldGradientMidOpacity = 0.50;
  static const Color fieldGradientEnd = Color(0xFFF4F7F8);

  static const Color accentColor = Color(0xFF5C85D9);

  static const Color errorColor = Color(0xFFAF3D3F);
  static const Color errorTextTranslucent = Color(0x80AF3D3F); // #AF3D3F @ 50%

  static const Color heartRed = Color(0xFFAF3D3F);

  static const Color headingColor = Color(0xFF57695D);
  static const Color buttonPrimary = headingColor;

  /// Muted green used for subtitle/helper text under headings.
  /// UNCHANGED — not mentioned as part of this rebrand.
  static const Color greenText = Color(0xFF94B289);

  static const Color successGreen = Color(0xFF34C759); // score bar fill, "High" confidence
  static const Color scoreTrackDark = Color(0xFF1C1C1E); // unfilled portion of score bar
  static const Color conditionTintRed = Color(0xFFFBE2E2); // Resting Heart Rate card bg
  static const Color conditionTintBlue = Color(0xFFE3EBFA); // Sleep / Blood Pressure card bg
  static const Color conditionTintPurple = Color(0xFFEDE7FA); // Step Count card bg
  static const Color burdenBarYellow = Color(0xFFF2C230); // Burden Breakdown chart bars
  static const Color burdenBarRed = Color(0xFFE5484D); // "Inherited Risk" bar (highlighted)

  static const Color darkSurface = Color(0xFFC1C1C1); // this screen's app bar
  static const Color lightGreyFill = Color(0xFFF2F2F2); // manual-entry text field bg
  static const Color cardBorder = Color(0xFFE0E0E0); // Set Reminder card outline
  static const Color chipSelectedOrange = Color(0xFFF5A94C); // selected hour/day chip
  static const Color chipUnselectedGrey = Color(0xFFEDEDED); // unselected hour/day chip

  // ---------------------------------------------------------------------
  // Neutrals
  // ---------------------------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color divider = Color(0xFF6B6B6B);
  static const Color unselectedChipBorder = Color(0xFF57695D);
  static const Color inputText = Color(0xFF2C2C2C);
  static const Color hintText = Color(0x99566860);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  // ---------------------------------------------------------------------
  // ChipColors
  // ---------------------------------------------------------------------
  static const Color allChipBackground = Color(0xFFE7F0FD);
  static const Color riskChipBackground = Color(0x33EF4444);
  static const Color moderateChipBackground = Color(0x33FACC15);
  static const Color normalChipBackground = Color(0x3332D74B);
  static const Color chartGridLine = Color(0xFFE5E7EB);

 // Score ring gauge gradient (Heart Score card)// ---------------------------------
  static const Color scoreRingYellow = Color(0xFFFDE047);
  static const Color scoreRingGreenLight = Color(0xFF34D399);
  static const Color scoreRingGreenDark = Color(0xFF10B981);
  // Gradients (ready-to-use)
  // ---------------------------------------------------------------------
  static const LinearGradient splashRadialFallbackGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [splashGradientEnd, splashGradientStart],
  );

  static RadialGradient splashGradient({double radius = 1.2}) => RadialGradient(
    center: const Alignment(0, -0.2),
    radius: radius,
    colors: const [splashGradientEnd, splashGradientStart],
    stops: const [0.0, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter, // vertical: blue tint top
    end: Alignment.bottomCenter, // -> off-white bottom
    colors: [cardGradientStart, cardGradientEnd],
  );

  static LinearGradient get fieldGradient => LinearGradient(
    begin: Alignment.topCenter, // horizontal: dark green (67%) left
    end: Alignment.bottomCenter, // -> pale grey -> white, right
    colors: [
      fieldGradientStart.withOpacity(fieldGradientStartOpacity),
      fieldGradientMid.withOpacity(fieldGradientMidOpacity),
      fieldGradientEnd,
    ],
    stops: const [0.0, 0.85, 1.0],
  );
}


