// services/report_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leaderboard_user.dart';
import 'auth_service.dart';

class ReportService {
  static const String _baseUrl = 'https://quiz-api.camtech-dev.online';

  /// Submits the result of a completed quiz to the backend.
  static Future<bool> submitReport({
    required int score,
    required int totalQuestion,
    required int totalCorrect,
    required String categoryEn,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final url = Uri.parse('$_baseUrl/api/report/submit');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'score': score,
          'totalQuestion': totalQuestion,
          'totalCorrect': totalCorrect,
          // Assuming the API can accept the English name for all language fields for now
          'categoryEn': categoryEn,
          'categoryKh': categoryEn, 
          'categoryZh': categoryEn,
        }),
      );
      // A successful submission should return a 2xx status code (e.g., 200 OK or 201 Created)
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error submitting report: $e');
      return false;
    }
  }

  /// Fetches the top 10 players for the leaderboard.
  static Future<List<LeaderboardUser>> getTopPlayers() async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/api/report/top10/player');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // The API returns a list of objects directly.
        final List<dynamic> responseData = jsonDecode(response.body);
        // We map each JSON object in the list to our LeaderboardUser model.
        return responseData.map((json) => LeaderboardUser.fromJson(json)).toList();
      } else {
         print('Failed to load leaderboard. Status code: ${response.statusCode}');
         print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching top players: $e');
      return [];
    }
  }
}