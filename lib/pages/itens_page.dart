import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/utilities/theme_notifier.dart';
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
      appBar: AppBar(
        title: Text(
          texts['dashboard'][1],
        ),
      ),
      bottomNavigationBar: DefaultBottomAppBar(texts: texts),
      drawer: DefaultDrawer(theme: theme, texts: texts),
      body: HelperClass(
        mobile: const Text('Itens Page'),
        tablet: const Placeholder(),
        desktop: const Placeholder(),
        paddingWidth: size.width * .1,
        bgColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
