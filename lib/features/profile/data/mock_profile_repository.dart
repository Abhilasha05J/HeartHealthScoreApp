import '../domain/profile_data.dart';
import '../domain/profile_repository.dart';

/// TODO(backend-integration): replace with `ApiProfileRepository` once the
/// backend exposes a profile read/update endpoint. Seed values copied
/// from the mockup so the UI matches while data is mocked.
class MockProfileRepository implements ProfileRepository {
  UserProfile _profile = const UserProfile(
    fullName: 'Shruti Solanki',
    email: 'shruti@gmail.com',
    heightCm: 172,
    weightKg: 68,
    // Daily calories / protein target are shown as empty hint placeholders
    // ("2200" / "170") in the mockup — left null here to match.
  );

  @override
  Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = profile;
    return _profile;
  }
}
