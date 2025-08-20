// models/test_result.dart
import 'dart:convert';
import 'question_quiz.dart';

class TestResult {
  String category;
  int score;
  int totalQuestions;
  DateTime completedAt;
  List<QuestionQuiz> questions;

  TestResult({
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.questions,
  });

  // 1. Add a toJson method to convert a TestResult to a Map
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': completedAt.toIso8601String(), // Convert DateTime to a standard string format
      // Convert the list of QuestionQuiz objects to a list of Maps
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  // 2. Add a fromJson factory to create a TestResult from a Map
  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      category: json['category'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      completedAt: DateTime.parse(json['completedAt']), // Parse the string back to DateTime
      // Convert the list of Maps back to a list of QuestionQuiz objects
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuestionQuiz.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}