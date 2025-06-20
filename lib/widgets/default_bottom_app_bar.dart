import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockchef/utilities/language_notifier.dart';
import 'package:stockchef/widgets/default_bottom_button.dart';

class DefaultBottomAppBar extends ConsumerWidget {
  const DefaultBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map texts = ref.watch(languageNotifierProvider)['texts'];
    return BottomAppBar(
      height: 70,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          DefaultBottomButton(
            text: texts['dashboard'][1],
            icon: Icons.shelves,
            action: () {
              Navigator.pushNamed(context, '/items');
            },
          ),
          const VerticalDivider(),
          DefaultBottomButton(
            text: texts['dashboard'][0],
            icon: Icons.dashboard,
            action: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          const VerticalDivider(),
          DefaultBottomButton(
            text: texts['dashboard'][2],
            icon: Icons.soup_kitchen,
            action: () {
              Navigator.pushNamed(context, '/preparations');
            },
          )
        ],
      ),
    );
  }
}
