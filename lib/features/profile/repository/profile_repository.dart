import '../model/app_user.dart';

/// Contract for the profile screen.
abstract class ProfileRepository {
  Future<AppUser> fetchProfile();
}
