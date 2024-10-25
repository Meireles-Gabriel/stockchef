import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super(PlatformDispatcher.instance.locale.languageCode) {
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('language') ??
        (PlatformDispatcher.instance.locale.languageCode == 'pt' ? 'pt' : 'en');
  }

  void toggleLanguage(bool isEnglish) {
    state = isEnglish ? 'en' : 'pt';
  }
}

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, String>(
  (ref) {
    return LanguageNotifier();
  },
);
