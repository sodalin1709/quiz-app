// models/quiz_category.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class QuizCategory {
  final int id;
  final String nameEn;
  final String nameKh;
  final String nameZh;
  final String iconUrl;
  int? questionCount;

  QuizCategory({
    required this.id,
    required this.nameEn,
    required this.nameKh,
    required this.nameZh,
    required this.iconUrl,
    this.questionCount,
  });

  /// Returns the category name in the currently selected language.
  String getName(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).currentLanguage;
    switch (lang) {
      case Language.en:
        return nameEn;
      case Language.kh:
        return nameKh;
      case Language.zh:
        return nameZh;
    }
  }

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['id'] ?? 0,
      nameEn: json['nameEn'] ?? 'Untitled',
      nameKh: json['nameKh'] ?? 'Untitled',
      nameZh: json['nameZh'] ?? 'Untitled',
      iconUrl: json['iconUrl'] ?? '',
      questionCount: (json['questions'] as List?)?.length,
    );
  }
}