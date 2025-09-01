// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // TODO: Replace with your actual base URL
  static const String _baseUrl = 'https://quiz-api.camtech-dev.online';
  static const String _tokenKey = 'auth_token';

  /// Sends an OTP to the given phone number.
  static Future<bool> sendOtp(String countryCode, String phone) async {
    final url = Uri.parse('$_baseUrl/api/auth/otp/send');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'countryCode': countryCode,
          'phone': phone,
        }),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  /// Registers a new user with phone, OTP, and password.
  static Future<bool> register(String countryCode, String phone, String otp, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'countryCode': countryCode,
          'phone': phone,
          'otp': otp,
          'password': password,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('token')) {
          await _saveToken(responseData['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  /// Logs in a user with their country code, phone, and password.
  static Future<bool> login(String countryCode, String phone, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'countryCode': countryCode,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('token')) {
          await _saveToken(responseData['token']);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }
  
  /// Resets user password using phone, OTP, and new password.
  static Future<bool> resetPassword(String countryCode, String phone, String otp, String newPassword) async {
    final url = Uri.parse('$_baseUrl/api/auth/password/reset');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'countryCode': countryCode,
          'phone': phone,
          'otp': otp,
          'password': newPassword,
        }),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }

  /// Logs out the user by deleting their token.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Checks for a saved token to auto-login the user.
  static Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  /// Saves the auth token to persistent storage.
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  /// Retrieves the saved auth token.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}












// // services/auth_service.dart
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user.dart';

// class AuthService {
//   static User? _currentUser;
//   static const String _userKey = 'current_user';

//   static User? get currentUser => _currentUser;

//   // ... (tryAutoLogin and login methods are fine) ...
//   static Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey(_userKey)) {
//       return false;
//     }

//     final extractedUserData = jsonDecode(prefs.getString(_userKey)!) as Map<String, dynamic>;
//     _currentUser = User.fromJson(extractedUserData);
//     return true;
//   }
  
//   static Future<bool> login(String email, String password) async {
//     await Future.delayed(Duration(seconds: 1));
    
//     if (email.isNotEmpty && password.isNotEmpty) {
//       _currentUser = User(
//         name: "John Doe",
//         email: email,
//         age: 20,
//         school: "ABC University",
//         gender: "Male",
//       );
//       await _saveUserSession(_currentUser!);
//       return true;
//     }
//     return false;
//   }

//   // 1. Modify the signUp method signature
//   static Future<bool> signUp(String name, String email, String password, String school, int age, String gender) async {
//     await Future.delayed(Duration(seconds: 1));
    
//     if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
//       // 2. Create the User object with all the details from the form
//       _currentUser = User(
//         name: name,
//         email: email,
//         age: age,
//         school: school,
//         gender: gender,
//       );
//       await _saveUserSession(_currentUser!);
//       return true;
//     }
//     return false;
//   }
  
//   // ... (logout, _saveUserSession, etc. methods are fine) ...
//   static Future<void> logout() async {
//     _currentUser = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userKey);
//   }

//   static Future<void> _saveUserSession(User user) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userData = jsonEncode(user.toJson());
//     await prefs.setString(_userKey, userData);
//   }
  
//   static Future<bool> resetPassword(String email) async {
//     await Future.delayed(Duration(seconds: 1));
//     return email.isNotEmpty;
//   }
  
//   static void updateProfile(User updatedUser) {
//     _currentUser = updatedUser;
//     _saveUserSession(updatedUser);
//   }
// }