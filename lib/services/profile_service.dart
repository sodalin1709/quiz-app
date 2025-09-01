// services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import 'auth_service.dart';

class ProfileService {
  static const String _baseUrl = 'https://quiz-api.camtech-dev.online';

  static Future<UserProfile?> getProfile() async {
    final token = await AuthService.getToken();
    if (token == null) {
       print('ProfileService Error: Auth token is null.');
      return null;
    }

    final url = Uri.parse('$_baseUrl/api/profile/info');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // --- ADD THESE TWO LINES FOR DEBUGGING ---
      print('Get Profile Status Code: ${response.statusCode}');
      print('Get Profile Response Body: ${response.body}');
      // -----------------------------------------

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserProfile.fromJson(responseData);
      }
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  /// Updates the user's first and last name.
  static Future<bool> updateProfile(String firstName, String lastName) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final url = Uri.parse('$_baseUrl/api/profile/info/update');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Changes the user's password.
  static Future<bool> changePassword(String newPassword) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final url = Uri.parse('$_baseUrl/api/profile/password/change');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'password': newPassword,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}