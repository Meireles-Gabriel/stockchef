import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
// Importa o provider

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Tema'),
          SwitchListTile(
            title: const Text('Modo Escuro'),
            value: isDarkMode,
            onChanged: (value) async {
              ref.read(themeNotifierProvider.notifier).toggleTheme(value);
              final prefs = await SharedPreferences.getInstance();
              final themeMode = ref.watch(themeNotifierProvider);
              await prefs.setInt('themeMode', themeMode.index);
            },
          ),
        ],
      ),
    );
  }
}
