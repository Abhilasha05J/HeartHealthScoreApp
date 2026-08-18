import 'profile_data.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();

  Future<UserProfile> updateProfile(UserProfile profile);
}
