// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../data/mock_profile_repository.dart';
// import '../domain/profile_data.dart';
// import '../domain/profile_repository.dart';
//
// final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
//   return MockProfileRepository();
// });
//
// class ProfileController extends StateNotifier<AsyncValue<UserProfile>> {
//   ProfileController(this._repo) : super(const AsyncValue.loading()) {
//     _load();
//   }
//
//   final ProfileRepository _repo;
//
//   Future<void> _load() async {
//     state = const AsyncValue.loading();
//     try {
//       final profile = await _repo.fetchProfile();
//       state = AsyncValue.data(profile);
//     } catch (error, stack) {
//       state = AsyncValue.error(error, stack);
//     }
//   }
//
//   Future<void> save(UserProfile updated) async {
//     final previous = state;
//     state = AsyncValue.data(updated); // optimistic update
//     try {
//       final saved = await _repo.updateProfile(updated);
//       state = AsyncValue.data(saved);
//     } catch (error, stack) {
//       state = previous;
//       rethrow;
//     }
//   }
// }
//
// final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<UserProfile>>((ref) {
//   return ProfileController(ref.watch(profileRepositoryProvider));
// });
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/core/local/profile_local_store.dart';
import 'package:heart_health_score/features/auth/application/auth_providers.dart';

import '../data/api_profile_repository.dart';
import '../domain/profile_data.dart';
import '../domain/profile_repository.dart';

/// Repository provider — the ONLY line to change to develop offline
/// (swap for `MockProfileRepository()` from
/// `features/profile/data/mock_profile_repository.dart`).
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ApiProfileRepository(
    ref.watch(profileLocalStoreProvider),
    currentUser: () => ref.read(currentUserProvider),
  );
});

class ProfileController extends StateNotifier<AsyncValue<UserProfile>> {
  ProfileController(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  final ProfileRepository _repo;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repo.fetchProfile();
      state = AsyncValue.data(profile);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> save(UserProfile updated) async {
    final previous = state;
    state = AsyncValue.data(updated); // optimistic update
    try {
      final saved = await _repo.updateProfile(updated);
      state = AsyncValue.data(saved);
    } catch (error, stack) {
      state = previous;
      rethrow;
    }
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<UserProfile>>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider));
});