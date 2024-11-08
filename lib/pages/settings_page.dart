import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/helper_class.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/widgets/default_bottom_app_bar.dart';
import 'package:stockchef/widgets/default_drawer.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          texts['dashboard'][3],
        ),
      ),
      bottomNavigationBar: const DefaultBottomAppBar(),
      drawer: const DefaultDrawer(),
      body: HelperClass(
        mobile: const Text('Settings Page'),
        tablet: const Placeholder(),
        desktop: const Placeholder(),
        paddingWidth: size.width * .1,
        bgColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
