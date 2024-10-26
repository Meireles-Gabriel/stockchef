import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/theme_notifier.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sunny),
          Transform.scale(
            scale: .8,
            child: Switch(
              value: isDarkMode,
              onChanged: (value) async {
                ref.read(themeNotifierProvider.notifier).toggleTheme(value);
              },
            ),
          ),
          const Icon(Icons.nightlight),
        ],
      );
    });
  }
}
