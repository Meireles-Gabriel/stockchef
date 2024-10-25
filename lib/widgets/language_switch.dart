import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/texts.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentLanguage = ref.watch(languageNotifierProvider);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              // ref.read(textsNotifierProvider.notifier).state =
              //     value == 'pt' ? portugueseTexts : englishTexts;
              final isEnglish = value == 'en';
              ref.read(textsNotifierProvider.notifier).toggleTexts(isEnglish);
              ref
                  .read(languageNotifierProvider.notifier)
                  .toggleLanguage(isEnglish);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'en',
                child: Text('EN'),
              ),
              const PopupMenuItem(
                value: 'pt',
                child: Text('PT'),
              ),
            ],
            icon: Row(
              children: [
                const Icon(Icons.language),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  currentLanguage == 'en' ? 'EN' : 'PT',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
