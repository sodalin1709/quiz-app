// services/quiz_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_quiz.dart';
import '../models/test_result.dart';
import 'auth_service.dart';

class QuizService {
  static const String _baseUrl = 'https://quiz-api.camtech-dev.online';
  
  // This list will hold the test history in memory after being loaded from local storage.
  static List<TestResult> testHistory = [];

  /// Fetches questions for a category by getting the category's detail from the API.
  static Future<List<QuestionQuiz>> getQuestions(int categoryId) async {
    final token = await AuthService.getToken();
    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/api/category/$categoryId/detail');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> questionList = responseData['questions'] ?? [];
        return questionList.map((json) => QuestionQuiz.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching questions for category $categoryId: $e');
      return [];
    }
  }
  
  /// Saves a completed test result to the device's local storage.
  static Future<void> saveTestResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    
    // FIX: Read the latest history from storage first to prevent overwriting.
    final List<String> historyJson = prefs.getStringList('test_history') ?? [];
    List<TestResult> currentHistory = historyJson.map((res) => TestResult.fromJson(jsonDecode(res))).toList();

    // Add the new result to the top of the list we just loaded.
    currentHistory.insert(0, result);

    // Update the in-memory list for the UI to use immediately.
    testHistory = currentHistory;
    
    // Convert the updated list back to JSON strings.
    List<String> newHistoryJson = currentHistory.map((res) => jsonEncode(res.toJson())).toList();
    
    // Save the complete, updated list back to storage.
    await prefs.setStringList('test_history', newHistoryJson);
  }

  /// Loads the test history from local storage into the in-memory list.
  static Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('test_history');
    
    if (historyJson != null) {
      testHistory = historyJson.map((resString) => TestResult.fromJson(jsonDecode(resString))).toList();
    }
  }
}