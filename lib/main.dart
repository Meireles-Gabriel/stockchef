import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/pages/dashboard_page.dart';
import 'package:stockchef/pages/intro_page.dart';
import 'package:stockchef/pages/login_page.dart';
import 'package:stockchef/pages/payment_page.dart';
import 'package:stockchef/pages/sell_page.dart';
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
      final languageConfig = ref.watch(languageNotifierProvider);
      final themeMode = ref.watch(themeNotifierProvider);
      return MaterialApp(
        locale: Locale(languageConfig['language']),
        debugShowCheckedModeBanner: false,
        title: 'StockChef',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const IntroPage(),
        routes: {
          '/intro': (context) => const IntroPage(),
          '/login': (context) => const LoginPage(),
          '/sell': (context) => const SellPage(),
          '/payment': (context) => const PaymentPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      );
    });
  }
}
