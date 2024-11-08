import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/providers.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentLanguage = ref.watch(languageNotifierProvider)['language'];
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PopupMenuButton<String>(
            tooltip:
                currentLanguage == 'pt' ? 'Change Language' : 'Mudar Idioma',
            color: Theme.of(context).colorScheme.surface,
            onSelected: (value) async {
              final isEnglish = value == 'en';
              ref
                  .read(languageNotifierProvider.notifier)
                  .toggleLanguage(isEnglish);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', value);
              if (ref.watch(unitItemProvider) == 'Select Unit' ||
                  ref.watch(unitItemProvider) == 'Selecinar Unidade') {
                ref.read(unitItemProvider.notifier).state =
                    ref.watch(languageNotifierProvider)['language'] == 'en'
                        ? 'Select Unit'
                        : 'Selecionar Unidade';
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en',
                child: Center(
                  child: Text(
                    'English',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'pt',
                child: Center(
                  child: Text(
                    'Português',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
            icon: Row(
              children: [
                Text(
                  currentLanguage == 'en' ? 'EN' : 'PT',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  width: 7,
                ),
                const Icon(Icons.language),
              ],
            ),
          ),
        ],
      );
    });
  }
}
