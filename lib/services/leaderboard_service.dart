// // services/leaderboard_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/leaderboard_user.dart';
// import 'auth_service.dart';

// class LeaderboardService {
//   // TODO: Replace with your actual base URL
//   static const String _baseUrl = 'https://quiz-api.camtech-dev.online';

//   // NOTE: Your API spec does not list a leaderboard endpoint.
//   // We are assuming one exists at `/api/leaderboard`.
//   // The `filter` could be 'all', 'week', 'month'.
//   static Future<List<LeaderboardUser>> getLeaderboard(String filter) async {
//     final token = await AuthService.getToken();
//     if (token == null) return [];

//     final url = Uri.parse('$_baseUrl/api/leaderboard?filter=$filter');
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> userList = jsonDecode(response.body)['data'];
//         return userList.map((json) => LeaderboardUser.fromJson(json)).toList();
//       }
//       return [];
//     } catch (e) {
//       print('Error fetching leaderboard: $e');
//       return [];
//     }
//   }
// }