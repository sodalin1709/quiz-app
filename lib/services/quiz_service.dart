import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_category.dart';
import '../models/question_quiz.dart';
import '../models/test_result.dart';

class QuizService {
  static List<TestResult> _testHistory = [];
  static const String _historyKey = 'test_history';

  static List<TestResult> get testHistory => _testHistory;

  /// Loads the test history list from the device's persistent storage.
  static Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_historyKey)) {
      final historyData = prefs.getString(_historyKey)!;
      final decodedList = jsonDecode(historyData) as List<dynamic>;
      
      _testHistory = decodedList
          .map((item) => TestResult.fromJson(item as Map<String, dynamic>))
          .toList();
    }
  }

  /// Adds a new test result to the in-memory list and saves the updated
  /// list to the device's persistent storage.
  static Future<void> saveTestResult(TestResult result) async {
    _testHistory.add(result);
    final prefs = await SharedPreferences.getInstance();
    final historyData = jsonEncode(
      _testHistory.map((test) => test.toJson()).toList(),
    );
    await prefs.setString(_historyKey, historyData);
  }

  /// Returns a hardcoded list of top users for the leaderboard.
  static List<Map<String, dynamic>> getTopUsers() {
    return [
      {"name": "Rayford", "score": 1250},
      {"name": "Willard", "score": 1100},
      {"name": "Hannah", "score": 980},
      {"name": "Geoffrey", "score": 950},
      {"name": "Laverne", "score": 900},
      {"name": "Darrin", "score": 850},
      {"name": "Mckenzie", "score": 800},
      {"name": "Kirsten", "score": 750},
      {"name": "Lester", "score": 700},
      {"name": "Rae", "score": 650},
    ];
  }

  /// Returns a hardcoded list of quiz categories with names, icons, images,
  /// and question counts to match the new UI design.
  static List<QuizCategory> getQuizCategories() {
    return const [
      QuizCategory(
        name: "General Knowledge",
        icon: Icons.work,
        image: 'assets/general_knowledge.jpg', // Replace with your image asset
        questionCount: 16,
      ),
      QuizCategory(
        name: "Advanced Math",
        icon: Icons.lightbulb,
        image: 'assets/math.jpg', // Replace with your image asset
        questionCount: 10,
      ),
      QuizCategory(
        name: "Personlity Test",
        icon: Icons.science,
        image: 'assets/personality_test.jpg', // Replace with your image asset
        questionCount: 20,
      ),
      QuizCategory(
        name: "World History",
        icon: Icons.history_edu,
        image: 'assets/history.jpg', // Replace with your image asset
        questionCount: 15,
      ),
    ];
  }
}