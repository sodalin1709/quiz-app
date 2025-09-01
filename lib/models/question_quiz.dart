// models/question_quiz.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class QuestionQuiz {
  final String questionEn;
  final String questionKh;
  final String questionZh;
  final List<String> optionsEn;
  final List<String> optionsKh;
  final List<String> optionsZh;
  final String? answer;
  String? customerAnswer;
  int? index;

  QuestionQuiz({
    required this.questionEn,
    required this.questionKh,
    required this.questionZh,
    required this.optionsEn,
    required this.optionsKh,
    required this.optionsZh,
    required this.answer,
    this.customerAnswer,
    this.index,
  });

  /// Returns the question text in the currently selected language.
  String getQuestion(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    switch (lang) {
      case Language.en:
        return questionEn;
      case Language.kh:
        return questionKh;
      case Language.zh:
        return questionZh;
    }
  }

  /// Returns the list of options in the currently selected language.
  List<String> getOptions(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    switch (lang) {
      case Language.en:
        return optionsEn;
      case Language.kh:
        return optionsKh;
      case Language.zh:
        return optionsZh;
    }
  }

  factory QuestionQuiz.fromJson(Map<String, dynamic> json) {
    return QuestionQuiz(
      questionEn: json['questionEn'] ?? '',
      questionKh: json['questionKh'] ?? '',
      questionZh: json['questionZh'] ?? '',
      optionsEn: List<String>.from(json['optionEn'] ?? []),
      optionsKh: List<String>.from(json['optionKh'] ?? []),
      optionsZh: List<String>.from(json['optionZh'] ?? []),
      answer: json['answerCode'],
      customerAnswer: json['customerAnswer'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() => {
    'questionEn': questionEn, 'questionKh': questionKh, 'questionZh': questionZh,
    'optionEn': optionsEn, 'optionKh': optionsKh, 'optionZh': optionsZh,
    'answerCode': answer, 'customerAnswer': customerAnswer, 'index': index,
  };
}