import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> introPT = [
  'Teste de Linguagem',
];
List<String> introEN = [
  'Language Test',
];

Map<String, List<String>> portugueseTexts = {
  'intro': introPT,
};
Map<String, List<String>> englishTexts = {
  'intro': introEN,
};

class TextsNotifier extends StateNotifier<Map<String, List<String>>> {
  TextsNotifier() : super({}) {
    _loadTexts();
  }

  void _loadTexts() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('language') == null
        ? (PlatformDispatcher.instance.locale.languageCode == 'pt'
            ? portugueseTexts
            : englishTexts)
        : (prefs.getString('language') == 'pt'
            ? portugueseTexts
            : englishTexts);
  }

  void toggleTexts(bool isEnglish) {
    state = isEnglish ? englishTexts : portugueseTexts;
  }
}

final textsNotifierProvider =
    StateNotifierProvider<TextsNotifier, Map<String, List<String>>>(
  (ref) {
    return TextsNotifier();
  },
);
