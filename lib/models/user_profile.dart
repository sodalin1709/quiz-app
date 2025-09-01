// models/user_profile.dart

class UserProfile {
  final String firstName;
  final String lastName;
  final String phone;
  final String countryCode;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.countryCode,
  });

  // A factory constructor for creating a new UserProfile instance from a map.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }

  // A helper to create a display name
  String get fullName => '$firstName $lastName'.trim();
}