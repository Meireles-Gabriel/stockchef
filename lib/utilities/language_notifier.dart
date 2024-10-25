import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockchef/utilities/texts.dart';

class LanguageNotifier extends StateNotifier<Map<String, dynamic>> {
  LanguageNotifier()
      : super({
          'language': PlatformDispatcher.instance.locale.languageCode,
          'texts': englishTexts
        }) {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ??
        (PlatformDispatcher.instance.locale.languageCode == 'pt' ? 'pt' : 'en');

    state = {
      'language': languageCode,
      'texts': languageCode == 'pt' ? portugueseTexts : englishTexts
    };
  }

  void toggleLanguage(bool isEnglish) {
    final languageCode = isEnglish ? 'en' : 'pt';
    state = {
      'language': languageCode,
      'texts': isEnglish ? englishTexts : portugueseTexts
    };
  }
}

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, Map<String, dynamic>>(
  (ref) {
    return LanguageNotifier();
  },
);
