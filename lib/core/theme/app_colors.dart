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

  static const Color scoreCardGradientTop = Color(0xFFF0FDF4);

  // ── Score Gauge (semicircle tick dial) ───────────────────────────────
  static const Color scoreGaugeRed = Color(0xFFF87171);
  static const Color scoreGaugeOrange = Color(0xFFFB923C);
  static const Color scoreGaugeYellow = Color(0xFFFDE047);
  static const Color scoreGaugeLightGreen = Color(0xFF86EFAC);
  static const Color scoreGaugeDarkGreen = Color(0xFF16A34A);
  static const Color scoreGaugeLabelGrey = Color(0xFFB0B7B4);

// ── Improvement delta chip ────────────────────────────────────────────
  static const Color improvementChipBg = Color(0xFFD1FAE5);
  static const Color improvementChipText = Color(0xFF059669);

  static const Color darkSurface = Color(0xFFC1C1C1); // this screen's app bar
  static const Color lightGreyFill = Color(0xFFF2F2F2); // manual-entry text field bg
  static const Color cardBorder = Color(0xFFE0E0E0); // Set Reminder card outline
  static const Color chipSelectedOrange = Color(0xFFF5A94C); // selected hour/day chip
  static const Color chipUnselectedGrey = Color(0xFFEDEDED); // unselected hour/day chip


  static const Color ringGreen = Color(0xFF34C759); // steps ring/stat (same as successGreen)
  static const Color ringPurple = Color(0xFF9B5DE5); // calories ring/stat
  static const Color stepsTint = Color(0xFFE3F7EC); // Steps stat card bg
  static const Color caloriesTint = Color(0xFFF3EAFB); // Calories stat card bg
  static const Color mintChipBg = Color(0xFFD6F5E8); // "New Workout" / "Add Exercise" buttons
  static const Color mintChipText = Color(0xFF0B6B4F);
  static const Color weeklyBannerStart = Color(0xFF34D399); // "Workouts this week" banner
  static const Color weeklyBannerEnd = Color(0xFF60A5FA);
  static const Color workoutCardBg = Color(0xFFFFFFFF); // stat/summary/chart card backgrounds
  static const Color workoutTargetChipBg = Color(0x1F34C759); // "Target 6k" chip bg (ringGreen @ 12%)
  static const Color workoutProgressTrack = Color(0xFFEDEDED); // thin progress-rule bg on stat cards
// ── Weekly Achievements — Hydration Master ──────────────────────────
  static const Color hydrationBarFill = Color(0xFF38BDF8);
  static const Color hydrationBarTrack = Color(0xFFBAE6FD);

// ── Weekly Achievements — Daily Activity ring ────────────────────────
  static const Color activityRingTrack = Color(0xFFFED7AA);
  static const Color activityRingProgress = Color(0xFFFB923C);
  static const Color activityRingText = Color(0xFFEA580C);

// ── Weekly Achievements — Sleep Quality ──────────────────────────────
  static const Color sleepQualityValue = Color(0xFF9333EA);
  static const Color sleepQualityBarFill = Color(0xFFC084FC);
  static const Color sleepQualityBarTrack = Color(0xFFE9D5FF);

// ── Weekly Achievements — Vitals Stability ───────────────────────────
  static const Color vitalsStableBorder = Color(0xFF10B981);
  static const Color vitalsStableText = Color(0xFF059669);

// ── Rewards & Milestones ─────────────────────────────────────────────
  static const Color redeemLink = Color(0xFF32D74B);
  static const Color rewardsRingProgress = Color(0xFF34D399);
  static const Color rewardsSegmentFill = Color(0xFF34D399);
// ASSUMPTION: unfilled-segment / track color wasn't specified — using a
// neutral grey to match the greyed-out pip in the mockup. Swap if you
// have an exact hex.
  static const Color rewardsSegmentTrack = Color(0xFFE5E7EB);
  static const Color rewardsCardGlow = Color(0xFFD1FAE5);

// ── Unlocked Reward badge borders ────────────────────────────────────
  static const Color badgeHydrationBorder = Color(0xFFFEF08A);
  static const Color badgeSleepBorder = Color(0xFFE9D5FF);
  static const Color badgeStreakBorder = Color(0xFFFECACA);

  static const Color mealCaloriesProteinGreen = Color(0xFF006E1C);
  static const Color mealFatPurple = Color(0xFF8A5EFF);


  static const Color textSecondary = Color(0xFF8A93A3);
  static const Color profileHeaderEnd = Color(0xFFEFF3FE);
  static const Color textPrimary = Color(0xFF14181F);
  static const Color inputFieldBg = Color(0xFFF6F7FB);
  static const Color inputFieldBorder = Color(0xFFE4E7EF);
  static const Color navActive = Color(0xFF4C6FEF);
  static const Color profileAvatarBg = Color(0xFFCDEFE0);
  static const Color profileAvatarFg = Color(0xFF0E7A56);
  static const Color profileHeaderStart = Color(0xFFC9D6F7);
  static const LinearGradient profileHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [profileHeaderStart, profileHeaderEnd],
  );

  // plan screen---------------------------------------------------------------------
  static const Color planBasicCardBg = Color(0x45CC9DFD); // #CC9DFD @ 27%
  static const Color planModerateCardBg = Color(0xFFFFF2E7);
  static const Color planAdvanceCardBg = Color(0xFFFFF1FB);
  static const Color planOuterCardBg = Color(0xFFFCFCFC); // notched wrapper card
  static const Color planRecommendedBadgeBg = Color(0xFFFFD0A7);
  static const Color planRecommendedBadgeText = Color(0xFF00390A);
  static const Color planButtonBg = Color(0x5EBBBBBB); // #BBBBBB @ 37%
  static const Color planButtonText = black;
  static const Color planButtonShadow = Color(0x40000000); // #000000 @ 25%
  static const Color planOuterCardBorder = Color(0xFFE7E7E7);

  // parameters/assesments
  static const Color assessmentGreen = Color(0xFF13791F);
  static const Color assessmentFieldBorder = Color(0xFFBBCBB5);
  static const Color assessmentFieldBackground = Color(0xFFF5F6F7);
  static const Color assessmentMutedText = Color(0xFF9AA0A6);
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

  static const LinearGradient workoutScreenBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [stepsTint, conditionTintBlue, caloriesTint, white],
    stops: [0.0, 0.35, 0.75, 1.0],
  );

  static const LinearGradient weekBannerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [weeklyBannerStart, weeklyBannerEnd],
  );
}


abstract class FitnessTextStyles {
  FitnessTextStyles._();

  static const String _fontFamily = 'Manrope';

  static const TextStyle screenTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
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
    color: AppColors.textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
