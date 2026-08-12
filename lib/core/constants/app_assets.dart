/// Centralized asset path references — avoids magic strings scattered
/// across the codebase. Update here if you rename/move files in
/// assets/icons.
abstract class AppAssets {
  AppAssets._();

  static const String _iconsBase = 'assets/icons';

  static const String heartIcon = '$_iconsBase/heart_icon.png';
  static const String hhsLogo = '$_iconsBase/hhs_logo.png';
  static const String arrow = '$_iconsBase/arrow.png';
  static const String bloodPressure = '$_iconsBase/bp.png';
  static const String female = '$_iconsBase/female.png';
  static const String male = '$_iconsBase/male.png';
  static const String google = '$_iconsBase/google.png';
  static const String physicalActivity = '$_iconsBase/physical_activity.png';
  static const String restingHeartRate = '$_iconsBase/resting_hr.png';
  static const String sleep = '$_iconsBase/sleepr.png';
}
