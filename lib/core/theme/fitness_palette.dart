import 'package:flutter/material.dart';

/// Color + gradient tokens for the Workout, Nutrition and Profile screens.
///
/// ASSUMPTION: these three screens (mockups: workout dashboard with activity
/// rings, "Meals & Macros" nutrition tracker, "Your Profile") use a visually
/// distinct green/teal/purple language from the rest of the Heart Health
/// Score v2 rebrand (blue/slate, see `app_colors.dart`). Rather than bend
/// `AppColors` to cover two unrelated palettes, this file is kept separate
/// and only imported by the `workout`, `nutrition`, and `profile` features.
/// If design later unifies these into the main rebrand, fold this file into
/// `app_colors.dart` and delete it — don't let both live long-term.
abstract class FitnessPalette {
  FitnessPalette._();

  // ---- Screen background -------------------------------------------------
  // Soft diagonal wash: pale mint (top-left) -> pale lavender (bottom-right).
  static const Color bgMintStart = Color(0xFFE7F7EE);
  static const Color bgLavenderEnd = Color(0xFFF1EEFB);

  static const LinearGradient screenBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgMintStart, bgLavenderEnd],
  );

  // ---- Activity ring (outer -> inner: green, blue, purple) --------------
  static const Color ringSteps = Color(0xFF34C77B); // outer, green
  static const Color ringActiveTime = Color(0xFF4C6FEF); // mid, blue
  static const Color ringCalories = Color(0xFF9B5DE5); // inner, purple

  // ---- Pill / mint action buttons ----------------------------------------
  static const Color mintButtonBg = Color(0xFFC6F3E1);
  static const Color mintButtonFg = Color(0xFF0E7A56);

  // ---- Stat card accents (Steps / Active time / Calories headings) ------
  static const Color statStepsColor = ringSteps;
  static const Color statActiveTimeColor = ringActiveTime;
  static const Color statCaloriesColor = ringCalories;

  // ---- Teal "Workouts this week" banner ----------------------------------
  static const Color bannerTealStart = Color(0xFF14B89A);
  static const Color bannerTealEnd = Color(0xFF0E9488);

  static const LinearGradient weekBannerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bannerTealStart, bannerTealEnd],
  );

  // ---- Neutrals ------------------------------------------------------------
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundTint = Color(0xFFF8F9FC);
  static const Color textPrimary = Color(0xFF14181F);
  static const Color textSecondary = Color(0xFF8A93A3);
  static const Color divider = Color(0xFFE7E9EF);
  static const Color trackGrey = Color(0xFFD9DEE6);
  static const Color chipTargetBg = Color(0xFFE3FBF1);

  // ---- Nutrition-specific accents ----------------------------------------
  static const Color macroCalories = Color(0xFF23B26D); // green
  static const Color macroProtein = Color(0xFF23B26D); // green (icon bolt)
  static const Color macroCarbs = Color(0xFFF0A93B); // amber
  static const Color macroFat = Color(0xFF7C5CFC); // purple/indigo
  static const Color supplementAdd = Color(0xFF23B26D);

  // ---- Profile-specific accents -------------------------------------------
  static const Color profileHeaderStart = Color(0xFFC9D6F7);
  static const Color profileHeaderEnd = Color(0xFFEFF3FE);
  static const LinearGradient profileHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [profileHeaderStart, profileHeaderEnd],
  );
  static const Color profileAvatarBg = Color(0xFFCDEFE0);
  static const Color profileAvatarFg = Color(0xFF0E7A56);
  static const Color profileFabBg = Color(0xFF4C6FEF);
  static const Color inputFieldBg = Color(0xFFF6F7FB);
  static const Color inputFieldBorder = Color(0xFFE4E7EF);

  // ---- Bottom nav (shared shell) ------------------------------------------
  static const Color navActive = Color(0xFF4C6FEF);
  static const Color navInactive = Color(0xFF9AA2B1);
}

abstract class FitnessTextStyles {
  FitnessTextStyles._();

  static const String _fontFamily = 'Manrope';

  static const TextStyle screenTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: FitnessPalette.textPrimary,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: FitnessPalette.textPrimary,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: FitnessPalette.textPrimary,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle statTarget = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: FitnessPalette.textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: FitnessPalette.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: FitnessPalette.textSecondary,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
