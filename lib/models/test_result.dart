// models/test_result.dart
import 'question_quiz.dart';

class TestResult {
  final String category;
  final int categoryId;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final List<QuestionQuiz> questions;

  TestResult({
    required this.category,
    required this.categoryId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.questions,
  });

  // Convert a TestResult object into a Map
  Map<String, dynamic> toJson() => {
        'category': category,
        'categoryId': categoryId,
        'score': score,
        'totalQuestions': totalQuestions,
        'completedAt': completedAt.toIso8601String(), // Convert DateTime to a standard string
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  // Create a TestResult object from a Map
  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      category: json['category'],
      categoryId: json['categoryId'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      completedAt: DateTime.parse(json['completedAt']), // Parse string back to DateTime
      questions: (json['questions'] as List)
          .map((q) => QuestionQuiz.fromJson(q))
          .toList(),
    );
  }
}