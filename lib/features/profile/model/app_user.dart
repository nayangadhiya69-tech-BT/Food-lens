/// Demo user profile shown on the Profile tab.
///
/// This is sample content while the app runs on mock repositories — the app
/// does not collect or transmit any personal data.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.phoneDigits,
    required this.location,
  });

  final String id;
  final String name;

  /// 10-digit number used only for display (never stored in prefs).
  final String phoneDigits;

  final String location;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      phoneDigits: json['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phoneDigits,
        'location': location,
      };
}
