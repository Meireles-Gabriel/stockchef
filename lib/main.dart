import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/pages/dashboard_page.dart';
import 'package:stockchef/pages/intro_page.dart';
import 'package:stockchef/pages/login_page.dart';
import 'package:stockchef/pages/payment_page.dart';
import 'package:stockchef/pages/sell_page.dart';
import 'package:stockchef/utilities/auth_services.dart';
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
  String userSubscriptionType = 'not logged';

  Future<String> _userSubscriptionType() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;

        final docSnapshot =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        return docSnapshot.data()!['subscriptionType'];
      } else {
        return 'not logged';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar informações do usuário: $e\nLogging Out.');
      }
      try {
        AuthServices().logOut();
      } catch (e) {
        if (kDebugMode) {
          print('Falha no LogOut: $e');
        }
      }
      return 'not logged';
    }
  }

  Future<void> _initializeUserSubscriptionType() async {
    userSubscriptionType = await _userSubscriptionType();
  }

  @override
  void initState() {
    super.initState();
    _initializeUserSubscriptionType();
  }

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
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (userSubscriptionType == 'trial') {
                  return const SellPage();
                } else {
                  return const DashboardPage();
                }
              } else {
                return const IntroPage();
              }
            }),
        routes: {
          '/intro': (context) => const IntroPage(),
          '/login': (context) => LoginPage(),
          '/sell': (context) => const SellPage(),
          '/payment': (context) => const PaymentPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      );
    });
  }
}
