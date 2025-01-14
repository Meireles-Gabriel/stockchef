import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
import 'package:stockchef/widgets/default_drawer_button.dart';
import 'package:stockchef/widgets/language_switch.dart';
import 'package:stockchef/widgets/theme_switch.dart';

class DefaultDrawer extends ConsumerWidget {
  const DefaultDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    ThemeMode theme = ref.watch(themeNotifierProvider);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (Theme.of(context).brightness == Brightness.dark)
                      Container(
                        width: 71,
                        height: 71,
                        decoration: BoxDecoration(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Image.asset(
                      'assets/logo.png',
                      color: theme == ThemeMode.light
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      height: 70,
                    ),
                  ],
                ),
                Text(
                  'StockChef',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            children: [
              DefaultDrawerButton(
                action: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
                text: texts['dashboard'][0],
                icon: Icons.dashboard,
              ),
              const SizedBox(
                height: 1,
              ),
              DefaultDrawerButton(
                action: () {
                  Navigator.pushNamed(context, '/items');
                },
                text: texts['dashboard'][1],
                icon: Icons.shelves,
              ),
              const SizedBox(
                height: 1,
              ),
              DefaultDrawerButton(
                action: () {
                  Navigator.pushNamed(context, '/preparations');
                },
                text: texts['dashboard'][2],
                icon: Icons.soup_kitchen,
              ),
              const SizedBox(
                height: 50,
              ),
              DefaultDrawerButton(
                action: () {
                  Navigator.pushNamed(context, '/subscription');
                },
                text: texts['dashboard'][3],
                icon: Icons.card_membership,
              ),
              const SizedBox(
                height: 1,
              ),
              DefaultDrawerButton(
                action: () {
                  FirebaseServices().logOut(context);
                  Navigator.pushNamed(context, '/login');
                },
                text: texts['dashboard'][4],
                icon: Icons.switch_account,
              ),
              const SizedBox(
                height: 1,
              ),
              if (!kIsWeb)
                DefaultDrawerButton(
                  action: () {
                    exit(0);
                  },
                  text: texts['dashboard'][5],
                  icon: Icons.close,
                ),
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemeSwitch(),
                LanguageSwitch(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
