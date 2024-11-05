import 'package:flutter/material.dart';
import 'package:stockchef/widgets/default_bottom_button.dart';

class DefaultBottomAppBar extends StatelessWidget {
  const DefaultBottomAppBar({
    super.key,
    required this.texts,
  });

  final Map texts;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          DefaultBottomButton(
            text: texts['dashboard'][1],
            icon: Icons.shelves,
            action: () {
              Navigator.pushNamed(context, '/itens');
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
