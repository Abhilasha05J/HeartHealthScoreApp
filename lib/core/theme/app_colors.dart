import 'package:flutter/material.dart';

/// Centralized design-system colors for the Heart Health Score app.
///
/// Values are sourced directly from the UI/UX designer's Figma spec.
/// Do NOT hardcode hex colors anywhere else in the app — always reference
/// this class so the theme stays a single source of truth.
abstract class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Splash screen — radial gradient
  // ---------------------------------------------------------------------
  static const Color splashGradientStart = Color(0xFFFFC1C2);
  static const Color splashGradientEnd = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------
  // Auth / form section card — linear gradient (pink -> grey)
  // Used behind: login/signup card, Profile Setup card, Daily Activity
  // card, Basic Vitals card.
  // ---------------------------------------------------------------------
  static const Color cardGradientStart = Color(0xFFFFD5D5);
  static const Color cardGradientEnd = Color(0xFFEAEAEA);

  // ---------------------------------------------------------------------
  // Text field gradient background (3-stop linear gradient).
  // First stop is #334D35 at 67% opacity per spec.
  // ---------------------------------------------------------------------
  static const Color fieldGradientStart = Color(0xFF334D35); // used at 67% opacity
  static const double fieldGradientStartOpacity = 0.45;
  static const Color fieldGradientMid = Color(0xFFD8DFE3);
  static const Color fieldGradientEnd = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------
  // Accent colors
  // ---------------------------------------------------------------------
  /// Solid maroon/red — used for selected chips, slider thumb/track,
  /// stat highlights (e.g. "72 BPM").
  static const Color redAccent = Color(0xFFAF3D3F);

  /// Translucent red text color exactly as specified (#AF3D3F80 ~ 50% alpha).
  static const Color redTextTranslucent = Color(0x80AF3D3F);

  /// Primary action green (buttons: Send OTP / Login / Continue / Complete Setup).
  static const Color greenPrimary = Color(0xFF138D0A);

  /// Muted green used for subtitle/helper text under headings.
  static const Color greenText = Color(0xFF94B289);

  /// Page heading color (e.g. "Profile Setup", "Daily Activity").
  static const Color headingColor = Color(0xFF56685C);

  // ---------------------------------------------------------------------
  // Neutrals
  // ---------------------------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color unselectedChipBorder = Color(0xFF56685C);
  static const Color inputText = Color(0xFF2C2C2C);
  static const Color hintText = Color(0x99566860);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------
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
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [cardGradientStart, cardGradientEnd],
  );

  static LinearGradient get fieldGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      fieldGradientStart.withOpacity(fieldGradientStartOpacity),
      fieldGradientMid,
      fieldGradientEnd,
    ],
    stops: const [0.0, 0.65, 1.0],
  );
}
