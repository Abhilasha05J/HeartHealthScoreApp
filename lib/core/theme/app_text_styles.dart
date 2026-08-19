import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography for the app.
///
/// Fonts:
/// - Splash screen: MuseoModerno
/// - Rest of the app: Manrope

abstract class AppTextStyles {
  AppTextStyles._();

  // ---------------------------------------------------------------------
  // Splash — MuseoModerno
  // ---------------------------------------------------------------------

  static const TextStyle splashTitle = TextStyle(
    fontFamily: 'MuseoModerno',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const TextStyle splashFooter = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: AppColors.black,
  );

  // ---------------------------------------------------------------------
  // App-wide — Manrope
  // ---------------------------------------------------------------------

  static const TextStyle pageHeading = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.headingColor,
  );

  static const TextStyle pageSubtitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.greenText,
    height: 1.35,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    color: AppColors.inputText,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
    color: AppColors.inputText,
  );

  static const TextStyle inputValue = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.inputText,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.hintText,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle tabLabel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle linkText = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.inputText,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.accentColor,
  );

  static const TextStyle chipLabel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.inputText,
  );

  static const TextStyle appTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.headingColor,
  );

  static const TextStyle appTagline = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.greenText,
  );
  static const TextStyle dashboardcardheading = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.headingColor,
  );
}