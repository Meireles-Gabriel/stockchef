// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/firebase_services.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
import 'package:stockchef/widgets/add_stock_button.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_drawer.dart';

class ItensPage extends ConsumerWidget {
  const ItensPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    ThemeMode theme = ref.watch(themeNotifierProvider);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            texts['dashboard'][1],
          ),
        ),
        bottomNavigationBar: DefaultBottomAppBar(texts: texts),
        drawer: DefaultDrawer(theme: theme, texts: texts),
        body: FutureBuilder(
          future: FirebaseServices().getStocks(ref),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              if (kDebugMode) {
                print('Error getting Data');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              // Exibe os dados
              return HelperClass(
                mobile: Row(
                  children: [

                    AddStockButton(
                      texts: texts,
                      ref: ref,
                    ),
                  ],
                ),
                tablet: const Placeholder(),
                desktop: const Placeholder(),
                paddingWidth: size.width * .1,
                bgColor: Theme.of(context).colorScheme.surface,
              );
            } else {
              if (kDebugMode) {
                print('No data');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
