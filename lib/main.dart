import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockchef/pages/settings_page.dart';
import 'package:stockchef/utilities/firebase_options.dart';
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

  void saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final themeMode = ref.watch(themeNotifierProvider); // Observa o themeMode

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StockChef',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: const SettingsPage(),
      );
    });
  }

  //   return Scaffold(
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Text('Escolha o tema:'),
  //           SwitchListTile(
  //             title: const Text('Claro'),
  //             value: _themeMode == ThemeMode.light,
  //             onChanged: (bool value) {
  //               setState(() {
  //                 _themeMode = value ? ThemeMode.light : ThemeMode.dark;
  //                 _saveTheme(_themeMode);
  //               });
  //             },
  //           ),
  //           SwitchListTile(
  //             title: const Text('Escuro'),
  //             value: _themeMode == ThemeMode.dark,
  //             onChanged: (bool value) {
  //               setState(() {
  //                 _themeMode = value ? ThemeMode.dark : ThemeMode.light;
  //                 _saveTheme(_themeMode);
  //               });
  //             },
  //           ),
  //           SwitchListTile(
  //             title: const Text('Tema do Sistema'),
  //             value: _themeMode == ThemeMode.system,
  //             onChanged: (bool value) {
  //               setState(() {
  //                 _themeMode = value ? ThemeMode.system : ThemeMode.light;
  //                 _saveTheme(_themeMode);
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
