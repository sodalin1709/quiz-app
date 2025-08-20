// services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static User? _currentUser;
  static const String _sessionKey = 'current_user_session';
  static const String _allUsersKey = 'all_users_db';

  static User? get currentUser => _currentUser;

  /// Tries to log in a user automatically by checking for a saved session.
  static Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_sessionKey)) {
      return false;
    }

    final extractedUserData = jsonDecode(prefs.getString(_sessionKey)!) as Map<String, dynamic>;
    _currentUser = User.fromJson(extractedUserData);
    return true;
  }

  /// Logs in a user by finding their profile in the list of all registered users.
  static Future<bool> login(String email, String password) async {
    // In a real app, you would validate the password against a hashed version.
    // For this simulation, we'll just find the user by email.
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_allUsersKey)) {
      return false; // No users have ever signed up.
    }

    final allUsersData = prefs.getString(_allUsersKey)!;
    final List<dynamic> usersList = jsonDecode(allUsersData);
    
    final userMap = usersList.firstWhere(
      (user) => user['email'] == email,
      orElse: () => null,
    );

    if (userMap != null) {
      _currentUser = User.fromJson(userMap);
      await _saveUserSession(_currentUser!); // Save this user's session for auto-login
      return true;
    }

    return false; // User not found
  }

  /// Signs up a new user, adds them to the list of all users, and saves the session.
  static Future<bool> signUp(String name, String email, String password, String school, int age, String gender) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Load the existing list of all users
    List<dynamic> allUsers = [];
    if (prefs.containsKey(_allUsersKey)) {
      allUsers = jsonDecode(prefs.getString(_allUsersKey)!);
    }

    // 2. Check if email already exists
    if (allUsers.any((user) => user['email'] == email)) {
      // In a real app, you'd show a specific error message
      return false; 
    }

    // 3. Create the new user
    _currentUser = User(
      name: name,
      email: email,
      age: age,
      school: school,
      gender: gender,
    );

    // 4. Add the new user to the list and save it
    allUsers.add(_currentUser!.toJson());
    await prefs.setString(_allUsersKey, jsonEncode(allUsers));

    // 5. Save the new user's session for auto-login
    await _saveUserSession(_currentUser!);
    
    return true;
  }

  /// Logs out the current user and clears their session.
  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Saves the current user's data to the device for auto-login.
  static Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString(_sessionKey, userData);
  }

  /// Updates a user's profile in the main user list and in the current session.
  static Future<void> updateProfile(User updatedUser) async {
    _currentUser = updatedUser;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Update the user in the list of all users
    if (prefs.containsKey(_allUsersKey)) {
      final List<dynamic> allUsers = jsonDecode(prefs.getString(_allUsersKey)!);
      final userIndex = allUsers.indexWhere((user) => user['email'] == updatedUser.email);
      if (userIndex != -1) {
        allUsers[userIndex] = updatedUser.toJson();
        await prefs.setString(_allUsersKey, jsonEncode(allUsers));
      }
    }

    // Update the currently saved session
    await _saveUserSession(updatedUser);
  }
  
  static Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty;
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