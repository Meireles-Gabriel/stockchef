import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/pages/intro_page.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/firebase_options.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final locale = ref.watch(languageNotifierProvider);
      final themeMode = ref.watch(themeNotifierProvider);
      return MaterialApp(
        locale: Locale(locale),
        debugShowCheckedModeBanner: false,
        title: 'StockChef',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const IntroPage(),
      );
    });
  }
}
