import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// STOPGAP — same category as `OnboardingStatusStore`.
///
/// Height, weight, daily-calorie target, and protein target have no
/// backend home at all right now:
/// - Height/weight: the intake schema only stores computed `bmi`, never
///   raw height/weight (confirmed against `/intake/schema`).
/// - Calorie/protein targets: don't appear anywhere in the API.
///
/// So this data lives only on this device via shared_preferences, purely
/// so Profile doesn't reset to blank every time the app relaunches.
/// KNOWN LIMITATION: doesn't sync across devices or survive a reinstall —
/// only a real backend field fixes that. Replace this file's role
/// entirely once one exists.
class ProfileLocalStore {
  static const _key = 'hhs_profile_local_fields';

  Future<Map<String, dynamic>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> save({
    int? heightCm,
    int? weightKg,
    int? dailyCalories,
    int? proteinTargetG,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'heightCm': heightCm,
        'weightKg': weightKg,
        'dailyCalories': dailyCalories,
        'proteinTargetG': proteinTargetG,
      }),
    );
  }
}

final profileLocalStoreProvider = Provider<ProfileLocalStore>((ref) {
  return ProfileLocalStore();
});
