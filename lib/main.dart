// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stockchef/pages/create_item_page.dart';
import 'package:stockchef/pages/create_preparation_page.dart';
import 'package:stockchef/pages/dashboard_page.dart';
import 'package:stockchef/pages/edit_item_page.dart';
import 'package:stockchef/pages/edit_preparation_page.dart';
import 'package:stockchef/pages/intro_page.dart';
import 'package:stockchef/pages/items_page.dart';
import 'package:stockchef/pages/login_page.dart';
import 'package:stockchef/pages/preparations_page.dart';
import 'package:stockchef/pages/sell_page.dart';
import 'package:stockchef/pages/settings_page.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/design.dart';
import 'package:stockchef/utilities/firebase_options.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/stripe_services.dart';
import 'package:stockchef/utilities/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = StripeServices().pubKey;
  await Stripe.instance.applySettings();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String userSubscriptionType = 'not logged';
  List userReceiveFrom = [];

  Future<void> _userSubscriptionType() async {
    try {
      if (FirebaseServices().auth.currentUser != null) {
        String? userStripeId = await StripeServices()
            .getCustomerIdByEmail(FirebaseServices().auth.currentUser!.email!);

        if (userStripeId == null) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseServices().auth.currentUser!.uid)
              .update({'subscriptionId': '', 'subscriptionType': 'trial'});
        } else {
          String? subscriptionId =
              await StripeServices().getActiveSubscriptionId(userStripeId);
          if (subscriptionId == null) {
            FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseServices().auth.currentUser!.uid)
                .update({'subscriptionId': '', 'subscriptionType': 'trial'});
          } else {
            String? planId = await StripeServices().getPlanId(subscriptionId);
            if (planId == null) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseServices().auth.currentUser!.uid)
                  .update({'subscriptionId': '', 'subscriptionType': 'trial'});
            } else {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseServices().auth.currentUser!.uid)
                  .update({
                'subscriptionId': subscriptionId,
                'subscriptionType': (planId == StripeServices().soloBRLId ||
                        planId == StripeServices().soloUSDId)
                    ? 'solo'
                    : (planId == StripeServices().teamBRLId ||
                            planId == StripeServices().teamUSDId)
                        ? 'team'
                        : 'trial'
              });
            }
          }
        }
        final docSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseServices().auth.currentUser!.uid)
            .get();

        userSubscriptionType = docSnapshot.data()!['subscriptionType'];
        userReceiveFrom = docSnapshot.data()!['receiveFrom'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar informações do usuário: $e\nLogging Out.');
      }
      try {
        FirebaseServices().logOut(context);
      } catch (e) {
        if (kDebugMode) {
          print('Falha no LogOut: $e');
        }
      }
    }
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
                return FutureBuilder(
                  future: _userSubscriptionType(),
                  builder: (context, subscriptionSnapshot) {
                    if (subscriptionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Scaffold(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        appBar: AppBar(),
                        body: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return (userSubscriptionType == 'trial' &&
                              userReceiveFrom.isEmpty)
                          ? const SellPage()
                          : const DashboardPage();
                    }
                  },
                );
              } else {
                return const IntroPage();
              }
            }),
        routes: {
          '/intro': (context) => const IntroPage(),
          '/login': (context) => const LoginPage(),
          '/sell': (context) => const SellPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/items': (context) => const ItemsPage(),
          '/create_item':(context) => const CreateItemPage(),
          '/edit_item': (context) => const EditItemPage(),
          '/preparations': (context) => const PreparationsPage(),
          '/create_preparation': (context) => const CreatePreparationPage(),
          '/edit_preparation': (context) => const EditPreparationPage(),
          '/settings': (context) => const SettingsPage(),
        },
      );
    });
  }
}
