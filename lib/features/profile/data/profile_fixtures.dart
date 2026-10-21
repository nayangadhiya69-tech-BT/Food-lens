import '../model/app_user.dart';

/// Sample user matching the HTML design ("Hi Mahesh 👋 / Surat, Gujarat").
class ProfileFixtures {
  ProfileFixtures._();

  static const AppUser user = AppUser(
    id: 'demo-user',
    name: 'Mahesh',
    phoneDigits: '9876543210',
    location: 'Surat, Gujarat',
  );
}
