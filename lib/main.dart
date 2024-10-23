import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockchef/firebase_options.dart';
import 'package:stockchef/pages/intro_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    setState(() {
      _themeMode = ThemeMode.values[themeIndex];
    });
  }

  void _saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockChef',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: const IntroPage(),
    );
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
