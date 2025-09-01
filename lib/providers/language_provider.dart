// providers/language_provider.dart
import 'package:flutter/material.dart';

// An enum to represent the available languages
enum Language { en, kh, zh }

class LanguageProvider with ChangeNotifier {
  Language _currentLanguage = Language.en;

  Language get currentLanguage => _currentLanguage;

  // A map to get the next language in the cycle
  final Map<Language, Language> _nextLanguage = {
    Language.en: Language.kh,
    Language.kh: Language.zh,
    Language.zh: Language.en,
  };

  // A map to get the flag asset for the current language
  // Make sure you have these images in your assets folder!
  final Map<Language, String> _flags = {
    Language.en: 'assets/flag_en.png', // English flag
    Language.kh: 'assets/flag_kh.png', // Cambodian flag
    Language.zh: 'assets/flag_zh.png', // Chinese flag
  };

  String get currentFlag => _flags[_currentLanguage]!;

  /// Cycles through the available languages and notifies listeners to rebuild.
  void toggleLanguage() {
    _currentLanguage = _nextLanguage[_currentLanguage]!;
    // This tells any widget listening to this provider to rebuild
    notifyListeners();
  }
}